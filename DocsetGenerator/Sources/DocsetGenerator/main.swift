import Foundation
import GRDB
import Kanna

let env = ProcessInfo.processInfo.environment

guard let htmlPath = env["TBX_REF_PATH"],
      let docsetPath = env["TBX_DOCSET_PATH"] else {
          print("TBX_REF_PATH and TBX_DOCSET_PATH must be set to paths on your filesystem")
          exit(1)
      }

let docsetUrl = URL(fileURLWithPath: docsetPath)
let resourcesUrl = docsetUrl.appendingPathComponent("Contents/Resources")
let databaseUrl = resourcesUrl.appendingPathComponent("docSet.dsidx")
let htmlUrl = resourcesUrl.appendingPathComponent("Documents")

let fileManager = FileManager()
let dbQueue = try DatabaseQueue(path: databaseUrl.path)

enum ItemType: String, Codable {
    case Attribute
    case Guide
    case Operator
    case Resource
    case Section
    case Trait
    case `Type`
}

/// https://kapeli.com/docsets#createsqlite
struct SearchIndex: Codable, FetchableRecord, PersistableRecord {
    let id: Int64?
    let name: String
    let type: ItemType
    let path: String
}

let knownDirectoryItemTypes: [String: ItemType] = [
    htmlUrl.appendingPathComponent("index/Attributes/SystemAttributeList").path: .Attribute,
    htmlUrl.appendingPathComponent("index/ActionsRules/Operators/FullOperatorList").path: .Operator
]

func pageType(for pageUrl: URL) -> ItemType {
    let parent = pageUrl.deletingLastPathComponent()
    
    if let directoryType = knownDirectoryItemTypes[parent.path] {
        return directoryType
    }
    
    return .Guide
}

func parseFile(atPath path: String) throws -> SearchIndex {
    let pageUrl = URL(fileURLWithPath: path, relativeTo: htmlUrl)
    let doc = try HTML(url: pageUrl, encoding: .utf8)
    
    let name = doc.title ?? "Chapter"
    
    return SearchIndex(
        id: nil,
        name: name,
        type: pageType(for: pageUrl),
        path: path
    )
}

func copyFiles() throws {
    let htmlSourceUrl = URL(fileURLWithPath: htmlPath)
    
    try? fileManager.removeItem(at: htmlUrl)
    try fileManager.copyItem(at: htmlSourceUrl, to: htmlUrl)
    
    let iconSourceUrl = htmlSourceUrl.appendingPathComponent("images/tinderbox9sm.png")
    let iconUrl = docsetUrl.appendingPathComponent("icon.png")
    
    try? fileManager.removeItem(at: iconUrl)
    try fileManager.copyItem(at: iconSourceUrl, to: iconUrl)
}

func parseHtmlFiles() throws -> [SearchIndex] {
    let enumerator = fileManager.enumerator(atPath: htmlUrl.path)!
    
    var htmlFiles = [SearchIndex]()
    while let file = enumerator.nextObject() as? String {
        guard file.hasSuffix(".html"),
              let indexablePage = try? parseFile(atPath: file)
               else {
                  continue
              }
        htmlFiles.append(indexablePage)
    }
    
    return htmlFiles
}

try copyFiles()
let files = try parseHtmlFiles()

try dbQueue.write { db in
    if try db.tableExists("searchindex") {
        try db.drop(table: "searchindex")
    }
    try db.create(table: "searchindex") { t in
        t.autoIncrementedPrimaryKey("id")
        t.column("name", .text)
        t.column("type", .text)
        t.column("path", .text)
        t.uniqueKey(["name", "type", "path"], onConflict: .replace)
    }
    
    for file in files {
        try file.insert(db)
    }
}

print("Indexed \(files.count) files in the Tinderbox docset")
