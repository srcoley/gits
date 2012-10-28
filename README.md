# GITS v1.0

A command line tool to clone GitHub repositories by name or owner/name.

## Required

* Git (gits doesn't replace git)
* JSON.sh (included) 

## Install

### Auto

From the Terminal, follow these steps:

1. Download from GitHub - `git clone https://github.com/srcoley/gits.git`
1. Change directory to gits - `cd gits`
1. Source the installation file - `. install.sh`

### Manual

See: [What Does The Install File Do?](#what-does-the-install-file-do)

## Usage

There are two ways to run gits:

1. `gits <repo name>` - This methos performs a search via the `api.github.com/legacy/repos/search` endpoint. Once the repo owner/name of the first result has been determined, it gets cached and gits gets ran again using the second method below.
1. `gits <repo owner>/<repo name>` - This method clones directly from `https://github.com/<repo owner>/<repo name>.git`, skipping the cache.

## For the Initated

### What Does The Install File Do?</h3>

Two things:

* Moves gits' files to ~/.gits
* Adds `. ~/.gits/gits.sh` to the end of your .bash_profile file

### The "Cache"

Gits contains a cache file that keeps track of repo owner/name combinations for quicker cloning. By saving these combinations, the next time you run `gits <repo name>`, if anything in the cache matches `<repo name>`, gits will clone from GitHub without making a GET api search request.

## ToDo

* Add usage method `gits <repo name> all` to display the top 5 results from a search. User should be able to begin cloning by selecting 1-5.
* Update the `<repo owner>/<repo name>` method to save combos to the cache file.
* Better error handling.

## License

* MIT
* Apache 2
