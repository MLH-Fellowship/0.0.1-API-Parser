# 0.0.1-API-Parser
Parser for fixing this: https://github.com/Homebrew/brew/issues/5725

## Problem
Homebrew is used to install Software(Packages). Homebrew has formulae which determine how a package is installed. 
We want to automatically check if some of these formulae have newer versions which have just been released and if so we compare with the versions in Homebew and update the versions in Homebrew accordingly
## High Level Solution
- Fetch latest package version information from [repology.org](https://repology.org/) and store on file system.
- Fetch Homebrew Formulae information from [HomeBrew Formulae](https://formulae.brew.sh)
- Parse the JSON from both responses, format them them (trim and keep just the info we need like names and formulae versions) and store in  text files
- Compare Current Homebrew Formulae version numbers and those coming from Repology's APIs. If Homebrew has an old version, the Open a PR to update Homebrew Core Formulae
- Schedule the fetching of external APIs so it can have one or more times a day.
## Contributing
- Fork the repo from Upstream to your origin. The main repo is called the upstream and your fork is the origin
- Clone from your fork to the local system
- Add add a feature, create a new branch locally then make changes on the branch
- Push changes from your local branch to your fork of the repo
- Send a PR from your origin to the upstream
- When PR has been merged, rebase or pull from Upstream to keep working