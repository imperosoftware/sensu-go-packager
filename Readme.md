# Sensu-go OSS Packager

[Sensu][] provides a new, awesome version of Sensu, now called [sensu-go][] and it's open source. There's also a paid-for version, and sadly that's the only one that comes prebuilt for installation.

This repo is an attempt to build the OSS binaries and splice them into the enterprise deb packages for Debian, so we get the best of both worlds.

## Instructions

### Adding a new release

- Edit `versions.sh` to add the new version you want built
- Commit on a branch & open a pull request
- Check semaphore builds & tests the packages correctly, on the workflow page click "Package Release" and "Start promotion"
- New packages will be available from Gemfury to install
- Merge down PR

## Internals

The magic happens in `.semaphore/semaphore.yml`.

- Grab the sensu-go source code
- Compile the three binaries (agent, backend, cli)
- Smoke test all three to make sure they run/built okay
- Grab the upstream deb package for each of them
  - Expand the package
  - Replace the binary within the package
  - Update the package info
  - Pack the package back up into a deb file
