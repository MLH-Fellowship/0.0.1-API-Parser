# 0.0.1-API-Parser

Parser for fixing this: https://github.com/Homebrew/brew/issues/5725

## Overview

Homebrew is used to install software (packages). Homebrew uses 'formulae' to determine how a package is installed.
This project will automatically check which packages have had newer versions released. If Homebrew's formula for a given package is out-of-date, the project automatically submits a PR to update the Homebrew formula.

## High-level Solution

- Fetch latest package version information from [repology.org](https://repology.org/) and store on file system.
- Fetch Homebrew Formulae information from [HomeBrew Formulae](https://formulae.brew.sh)
- Parse the JSON from both responses, format them them (trim and keep just the info we need like names and formulae versions) and store in text files
- Compare Current Homebrew Formulae version numbers and those coming from Repology's APIs. If Homebrew has an old version, the Open a PR to update Homebrew Core Formulae
- Schedule the fetching of external APIs so it can have one or more times a day.

## Details

- This project can be run automatically at set intervals via GitHub Actions.
- First, run `ruby getHomeBrewJson.rb`. This file queries Homebrew itself for package data.
  - This file stores data in the `data/homebrew` directory. The resulting `.txt` file will be uniquely named with a timestamp.
  - Example of the data in this file for a given package:
  ```
  {"name"=>"a2ps", "oldname"=>nil, "versions"=>{"stable"=>"4.14", "devel"=>nil, "head"=>nil,
  "bottle"=>true}, "fullname"=>[nil, nil, {"stable"=>"4.14", "devel"=>nil, "head"=>nil,
  "bottle"=>true}], "download_url"=>"https://ftp.gnu.org/gnu/a2ps/a2ps-4.14.tar.gz"}
  ```
- Next, execute `ruby getRepologyJson.rb`. This file queries the Repology API to find packages that are out-of-date.
  - This file stores data in the `data/repology` directory. The resulting `.txt` file will be uniquely named with a timestamp.
  - Example of the data in this file for a given package:
  ```
  {"packagename"=>"2ping", "newestversion"=>"4.4.1", "srcname"=>"twoping",
  "visiblename"=>"twoping", "currentversion"=>"4.4"}
  ```
- Next, execute `ruby compareHomeBrewAndRepology.rb`. This file compares the data in the two `.txt` files produced by querying Homebrew and Repology. Subsequently, a new download URL for the latest version is generated. If the download URL proves to be valid, a checksum is also generated.
  - The resulting data is stored in `.txt` files in the `data` directory.
    - The `outdated_pckgs_no_update` directory holds data regarding packages that are out-of-date, but for which this project could not automatically generate an up-to-date download url.
    - The `outdated_pckgs_to_update` directory holds data regarding packages that are out-of-date, and for which a valid download url and checksum have been generated
    - Example of the data for a package ready to be updated:
    ```
    {"name"=>"abcl", "latest_version"=>"1.7.0",
    "old_url"=>"https://abcl.org/releases/1.6.1/abcl-src-1.6.1.tar.gz",
    "download_url"=>"https://abcl.org/releases/1.7.0/abcl-src-1.7.0.tar.gz",
    "checksum"=>"a5537243a0f9110bf23b058c152445c20021cc7989c99fc134f3f92f842e765d"}
    ```
- For each package listed in `data/outdated_pckgs_to_update/<FILE_NAME>`, a PR will automatically be submitted to Homebrew to update the package's formula to the latest version.
- Finally, execute `bumpFormulae.rb`. This file reads the lastest file from `data/outdated_pckgs_to_update` and then verifies each projet newwest version with livecheck command and then goes ahead to open a PR to homebrew core with the command `brew bump-formula-pr`

## Contributing

- Fork the repo from upstream to your origin. The main repo is called the 'upstream' and your fork is the 'origin'
- Clone from your fork to the local system
- Add add a feature, create a new branch locally then make changes on the branch
- Push changes from your local branch to your fork of the repo
- Send a PR from your origin to the upstream
- When PR has been merged, rebase or pull from upstream to keep working
