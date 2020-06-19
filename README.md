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
- Executing `ruby printPackageUpdates.rb` from the command line will query
  both the Repology and Homebrew APIs. Homebrew's current version of each
  package will be compared to the latest version of the package, per Repology's response.
- Each outdated package will be displayed to the console like so:

```
Package: kite
current => latest
1.0.4 => 2.20200512.1

Package: knock
current => latest
0.7 => 0.8

Package: l-smash
current => latest
2.9.1 => 2.14.5
```

## Contributing

- Fork the repo from upstream to your origin. The main repo is called the 'upstream' and your fork is the 'origin'
- Clone from your fork to the local system
- Add add a feature, create a new branch locally then make changes on the branch
- Push changes from your local branch to your fork of the repo
- Send a PR from your origin to the upstream
- When PR has been merged, rebase or pull from upstream to keep working
