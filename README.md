# arch-core

A manual and helper scripts for a minimal CoreOS + ArchLinux i686 setup

## Getting Started

Proposed workflow:

- An app is built on ArchLinux using a `Makefile` supporting `make` and `make DESTDIR=... install`
- Dependent ArchLinux packages are are specified in `PKGBUILD`
- The app is packaged into a binary `.pkg.tar.xz` Pacman package versioned by Mercurial revision number and hash.
- The package and its dependencies are installed into a minimal chroot using `pacman`
- A versioned docker image is made out of chroot using `docker import`. Container introspection to see versions of constituents is possible.
- Staging environment is set up using CoreOS on VmWare Player
- Production environment is set up using CoreOS on DigitalOcean cloud
- The image is pushed to staging (and eventually production) image registry using `docker push`
- A container is deployed to all machines in staging (and eventually production) clusters using  `fleetctl destroy && fleetctl start` and a global fleet unit.

Features:

- an up to date URL for prebuilt CoreOS VmWare images. Unlike the older 'insecure' image the newer official image comes with VmWare tools and doesn't contain any predefined SSH keys
- a minimal CoreOS setup: no `etcd` redundancy, no `locksmith` reboot scheduling, no `etcd` authentication
- a prototype `cloud-config` for one master node: contains `fleet`, image registry and `etcd`
- a prototype `cloud-config` for slaves: contains only `fleet`
- a sample unit for `fleet`: the app is deployed everywhere including the master node
- scripts to build `cloud-config` .iso files for VmWare Player - so a "secure" production VmWare image can be used
- locked-down CoreOS services:
  - everything including SSH runs on non-default TCP ports
  - `ntpd` is disabled:  out of the box it answers remote NTP queries so it is a potential remote exploitation loophole
  - `systemd-timesyncd`  is enabled instead. It still comes with stock CoreOS along with `ntpd` so no third-party software is used
  - password auth is disabled in SSHd - only keys
  - no public peer port on `etcd` as there are no peers
  - no public ports on fleet as `fleetctl` only needs a local Unix socket
  - `etcd` and `registry` are only running during software updates. 
  - SSH is the only non-application port open and it can still be closed if necessary: `fleetd` operates by polling `etcd` so it can start SSH back on request.
- a sample `PKGBUILD` pulling version tags from a local Mercurial DB
- `archlinux-base.sh` to build a base archlinux-i686 image.
- `pacstrap.sh` to build a minimal image using a novel approach: the image doesn't include base so it's truly minimal!
- a helper `docker-builder` image to serve as Arch-based `toolbox`
- a script for API-based fully automated provision of more slave nodes

## Used Placeholders

- `$APP_NAME` - a short name used as Archlinux package name, image name, systemd unit name, container name and folder name of Mercurial source tree.
- `$DESCRIPTION` - used as Archlinux package description and systemd unit description
- `$APP_PORT` - TCP port application listens to.
- `$REGISTRY_PORT`, `$ETCD_PORT`, `$SSH_PORT` - TCP ports to be used for image registry, etcd and sshd.
- `$REGISTRY_IP` - IP address of the master node. Only used on slave nodes.
- `[1234, 5678]` - DigitalOcean API numeric ids of SSH keys to add to provisioned nodes
- `$HOSTNAME` - host name of DigitalOcean node. It also shows up in DigitalOcean control panel, so choose a unique value for each node. It can be either a hostname or a FQDN and it is also used for DigitalOcean reverse DNS record for node IP.

`SEARCH_BACKEND=`, `SKIP`, `DESTDIR` etc are not placeholders

`$TOKEN` is not a placeholder either! Use `read TOKEN; export TOKEN` to paste your personal token to a terminal to avoid your token in shell history and similar logs.

`$public_ipv4` is not a placeholder. Well, it is technically a placeholder, but for DigialOcean API.
