# asl3-asterisk
This is the building enviornment for the `.deb` packages of 
Asterisk LTS + ASL3/app\_rpt. This repository is only
for the build scripts and the Quilt-compatible `debian/`
structure for package building.

This structure is forked from the Debian project's
Asterisk build environment located at
https://salsa.debian.org/pkg-voip-team/asterisk.

This repository is structure to track the Asterisk 20 LTS
release from the Asterisk project.

In general, this repo is used exclsively for the AllStarLink
project to build the asterisk-related packages via
GitHub and is not for general consumption. Feel free to
fork and use as desired but this project will generally not
provide any user support.

## Package version format
All packages created by this repo have the following version
format based on `deb-version(7)` manpage explanation.

```
 ${EPOCH}:${ASTERISK_VERSION}+asl3-${RPT_VER}-${PKG_RELEASE}

|----+---|--------+--------------------------X-----+--------X
     |            |                                |
     |            +-- "upstream-version"           |
     |                                             |
     +-- "epoch"               "debian-revision" --+
```

The values are defined as follows:

* `EPOCH` - By Debian Asterisk convention this is hardcoded as "2"

* `ASTERISK_VERSION` - The Asterisk LTS version upon which the version is based - e.g. 20.7.0

* `RPT_VER` - The version of the "app\_rpt" repo released for this build - e.g. 3.0

* `PKG_RELEASE` - The ASL3 project release version of the package build. Usually 1 unless there
was a problem specifically with package building that caused a new .deb publication needed.

A file generated from this repo using the versioning format above will be named,
for example `asl3-asterisk-20.7.0+asl3-1.0-1`. Note that the *epoch* does not appear
in the filename by debian convention.

## Building the .deb Files
The following is the loose process for building the
`.deb` files for installation.

1. On the build host, create a directory named `asl3`
or whatever you want to call the very root of the build process.
Change into that directory.

2. Pull the asl3-asterisk repository into the directory:
```
git clone git@github.com:AllStarLink/asl3-asterisk.git
```

3. Pull the app\_rpt repository into the directory:
```
git clone git@github.com:InterLinked1/app_rpt.git
```

4. Execute the `build-tree` process. For example:
``` 
asl3-asterisk/build-tree -a 20.5.0 -r 3 -v 0.0.2.fadead4
```

5. At the completion of the compilation, a number of `.deb`
files will be present.

## Information on build-tree
The build-tree script is simply a shell wrapper around the
creation of the final Quilt-compatible debian building 
environmnet. As much as possible, and without making it
impossible to track the upstream Asterisk build environment 
from Salsa, this is using standard Debian + DFSG semantics
for the build environment.

The build-tree script takes three options:

* `-a ASTERISK_VERSION` - The Asterisk version; e.g. 20.5.0

* `-v APP_RPT_VERSION` - The app\_rpt version. In prerelease this
is simply 0.0.n.${COMMIT\_ID} where n is monotonically increasing
and ${COMMIT\_ID} is the hash-tail from the Interlinked1/app\_rpt
repository. For example - 0.0.2.fadead4.

* `-r PKG RELEASE` - This is the Debian package release
version. In general, this will be 1 unless you're testing 
the exact same code base except for changes to the
build/patch system (i.e. things in the debian/ directory).
