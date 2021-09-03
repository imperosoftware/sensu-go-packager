# Sensu-go OSS Packager

[Sensu][] provides a new, awesome version of Sensu, now called [sensu-go][] and it's open source. There's also a paid-for version, and sadly that's the only one that comes prebuilt for installation.

This repo is an attempt to build the OSS binaries and splice them into the enterprise deb packages for Debian, so we get the best of both worlds.

The built packages then get hosted on Gemfury, and are publicly available as an apt source to be installed on Debian 9 amd64 nodes.

## Packages

All packages have the same version number as the commercial packages available from Sensu, but they all have `~ce` appended to denote they are the community edition packages.

### sensu-go-cli

Provides `sensuctl` community edition. No known changes to the commercial build.

### sensu-go-agent

Provides `sensu-agent` community edition. No known changes to the commercial build.

Includes configuration / systemd service file, etc same as commercial build.

### sensu-go-backend

Provides `sensu-backend` community edition. Does **not** include a web UI on port 3000, nor any of the commercial features.

Includes configuration / systemd service file same as the commercial build.

## Instructions

### Adding a new release

- Edit `versions.sh` to add the new version you want built
- Commit on a branch & open a pull request
- Check semaphore builds & tests the packages correctly, on the workflow page click "Package Release" and "Start promotion"
- New packages will be available from Gemfury to install
- Merge down PR

### Adding apt source to a machine

Add a new source list file so apt knows where to grab packages from

```sh
echo "deb [trusted=yes] https://apt.fury.io/impero/ /" | sudo tee /etc/apt/sources.list.d/impero_gemfury.list
```

Then `apt update` and install packages as you need.

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
