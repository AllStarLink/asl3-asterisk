# Theory of Operation
The `asl3-asterisk` repository is intended to hold **only**
the packaging environment to generate .deb files for
AllStarLink v3 elements that are directly linked to
Asterisk. This is, notably, the 
[app_rpt](https://github.com/AllStarLink/app_rpt)
module and its related channel drivers. 

# Building the .deb Files
In general, this is not done directly by a developer
but is leveraged by the automation build process. It 
is possible to run this manually for testing purposes.
However hand-compiled tests should not end up in the
Apt repositories.

The following is the loose process for building the
`.deb` files for installation:

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
asl3-asterisk/build-tree -a 20.7.0 -v 1.2 -r 1
```
See [Building Debs](./building_debs.md) for information
on what to spply for `-a`, `-r`, and `-v`.

5. At the completion of the compilation, a number of `.deb`
files will be present.

## build-tree
The `build-tree` script is simply a shell wrapper around the
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
repository. For example - 0.0.2.fadead4. In post-releast beta
testing and onward this will be a MAJOR.MINOR version number.

* `-r PKG RELEASE` - This is the Debian package release
version. In general, this will be 1 unless you're testing 
the exact same code base except for changes to the
build/patch system (i.e. things in the debian/ directory).

