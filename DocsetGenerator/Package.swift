// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DocsetGenerator",
    platforms: [
        .macOS(.v11)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .executable(
            name: "DocsetGenerator",
            targets: ["DocsetGenerator"]),
    ],
    dependencies: [
        .package(url: "git@github.com:tid-kijyun/Kanna.git", from: "5.2.7"),
        .package(url: "https://github.com/groue/GRDB.swift.git", from: "5.18.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(
            name: "DocsetGenerator",
            dependencies: ["Kanna", .product(name: "GRDB", package: "GRDB.swift")])
    ]
)
