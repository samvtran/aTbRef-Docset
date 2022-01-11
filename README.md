# A Tinderbox Reference File Dash Docset

This repository contains a [Dash](https://kapeli.com/dash) docset for [aTbRef](https://acrobatfaq.com/atbref9/), an invaluable resource for [Tinderbox](https://www.eastgate.com/Tinderbox/) users.

## Quickstart
- Download aTbRef.docset.zip from the latest release in the Releases tab
- Unzip the docset, put it somewhere safe, and open it in Dash
- Enjoy!

## What Works
- Dark mode
- Internal links (if any don't resolve correctly, please open an issue 🙏)
- _Open Online Page_ links to the online version at https://acrobatfaq.com/atbref9/

## TODO
- [ ] Ensure all links can resolve interally
- [ ] Host a docset feed
- [ ] Verify page types (most are guide)

## Modifications
The following modifications have been made to `aTbRef-9.tbx` file included in this repo:
- `here` quicklink has been removed since it's not particularly useful inside Dash
- Google Analytics, Google search, and DuckDuckGo search have been disabled.

## Generating Your Own Docset
Follow the directions at [Obtaining the aTbRef source TBX file](https://acrobatfaq.com/atbref9/index/AboutaTbRef/ObtainingtheaTbRefsource.html) to prepare a full HTML export of the aTbRef file.

After generating an export, open the DocsetGenerator project in Xcode. Edit the Run scheme of the project to include two environment variables:
- `TBX_REF_PATH` - The absolute path to aTbRef HTML export; e.g., `/Users/me/Documents/aTbRef Export`
- `TBX_DOCSET_PATH` - The absolute path to this repository's aTbRef.docset folder; e.g., `/Users/me/Documents/aTbRef-Docset/aTbRef.docset`

Run DocsetGenerator to generate the necessary files.

Finally, open the `aTbRef.docset` package with Dash to install the local docset.

## Licenses
DocsetGenerator is covered by the MIT license included in the `LICENSE` file.

All textual content is licensed as below:

A Tinderbox Reference File (c) by Mark Anderson

A Tinderbox Reference File is licensed under a
Creative Commons Attribution 4.0 International License.

You should have received a copy of the license along with this
work. If not, see <http://creativecommons.org/licenses/by/4.0/>.