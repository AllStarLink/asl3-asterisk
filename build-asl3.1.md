% build-asl3(1) ASL3 @@HEAD-DEVELOP@@
% Allan Nathanson
% August 2024

# NAME

build-asl3 - Build ASL3 Asterisk + app_rpt

# SYNOPSIS

Usage: `build-asl3 -a ASTV -v RPTV [-r RELV] [-d DESTDIR] [-l] ACTIONS`

Required options :

* -a  Asterisk version    (e.g. 20.9.2)
* -v  ASL/app_rpt version (e.g. 3.0.4)

Optional options :

* -r  Release version (default: 1)
* -d  local install directory (default: "/")
* -l  Create merged source directory with symlinks

Actions (specify one or more) :

* source  - create the merged source directory
* clean   - "clean" the merged source directory
* build   - "build" the source code
* install - "install" the build results, locally
* package - create Debian packages

Note: specifying the **build**, **install**, or **package** actions will, if needed, create the merged source directory.

Note: you can use the **AST\_VER**, **RPT\_VER**, and **REL\_VER** environment variables to specify the Asterisk, ASL/app_rpt, and Release versions.

# DESCRIPTION

ASL3 Asterisk + app_rpt includes multiple source code projects including [Asterisk](https://github.com/asterisk/asterisk.git), [app_rpt](https://github.com/AllStarLink/app_rpt.git), and [asl3-asterisk](https://github.com/AllStarLink/asl3-asterisk.git).

The command supports 2 different (but related) workflows :

1. Building Debian packages (asl3-asterisk-*)
2. Software development

## DIRECTORY HIERARCHY

When using the `build-asl3` command your system works with the following directory hierarchy :

```
<base directory>
  asl3-asterisk-AST_VER+asl3-ASL_VER
  asterisk
  app_rpt
  asl3-asterisk
```

The "asterisk", "app\_rpt", and "asl3-asterisk" directories contain the source code used to build ASL3 asterisk + app\_rpt.  The `build-asl3` script merges these 3 projects together into a single source directory, "asl3-asterisk-AST\_VER+asl3-ASL\_VER", that is used for building.

Any Debian packages created by `build-asl3` will also be stored in the "\<base directory>".

## WORKFLOW ACTIONS

Each workflow uses a subset of "actions".

### Action : **source**

The **source** action ensures that copies of the "asterisk", "app\_rpt", and "asl3-asterisk" projects are available on your system.  If the source code for any of these projects is not available it will be downloaded from the GitHub repository.  If the source code is already available it will be used as-is (including any source code changes you have made).

This action merges the "asterisk", "app\_rpt", and "asl3-asterisk" directories into the merged source directory.  If the merged directory already exists then its contents will be replaced.  If the directory does not exist it will be created.

This action also ensures that any [Debian] project dependencies needed for building ASL3 have been installed on the system.

Note: if you make any changes to the "asterisk", "app\_rpt", or "asl3-asterisk" directories you will need to repeat the **source** action to ensure that the merged directory includes those changes.

### Action : **build**

The **build** action compiles the source code in the merged directory.

### Action : **install**

The **install** action performs a "make install DESTDIR=/" in the merged directory.

Note: this action does **NOT** include everything in the "asl3-asterisk-*" packages.  The focus is on executables (e.g. asterisk) and modules (e.g. app_rpt.so, chan_simpleusb.so, etc).  The assumption we have made is that you are working on software (code) changes and you wish to test them on a system that already has ASL3 installed.

### Action : **package**

The **package** action creates the Debian "asl3-asterisk-*" packages.

### Action : **clean**

The **clean** action performs the equivalent of a "make clean" in the merged directory.

## TYPICAL WORKFLOWS

### Building Debian packages (asl3-asterisk-*)

This one's easy.  To build the "asl3-asterisk-*" Debian packages you can use the following command : 

```
git clone https://github.com/AllStarLink/asl3-asterisk.git  (if needed)
cd asl3-asterisk
./build-asl3 -a 20.9.2 -v 3.0.4 -r 1 source build package
```

Note: the `build-asl3` script is smart.  If the merged directory does not exist you can leave off the "source" and "build" actions (they will be automatically added).

### Software development

The following is an example of how you might use the `build-asl3` command to make a code change.

1. To start, you will want to grab a copy of the asl3-asterisk project (we need the "build-asl3" command).

	```
git clone https://github.com/AllStarLink/asl3-asterisk.git
```

2.  Optionally, you can [pre-]fetch a copy of the "asterisk" project and checkout the "tag" of the version you wish to use.  If you skip this step (and that's OK) we will download a copy of the "asterisk" source code.

	```
git clone https://github.com/asterisk/asterisk.git
(cd asterisk; git checkout 20.9.2)
```

3. Optionally, you can [pre-]fetch a copy of the "app\_rpt" project.  As above, if you wish to work with a specific version of "app\_rpt" then checkout it's "tag".   If you skip this step (and that's OK) we will download a copy of the "app\_rpt" source code.

	```
git clone https://github.com/AllStarLink/app_rpt.git
(cd app_rpt; git checkout 3.0.4)     <-- optional
```

4. Create (or update) the merged source directory.

	```
	cd asl3-asterisk
	./build-asl3 -a 20.9.2 -v 3.0.4 -r 1 source
	```

5. Build the sources in the merged source directory.

	```
	cd asl3-asterisk
	./build-asl3 -a 20.9.2 -v 3.0.4 -r 1 build
	```

6. Install (and test) your changes.

	```
	cd asl3-asterisk
	./build-asl3 -a 20.9.2 -v 3.0.4 -r 1 install
	```

7. Making iterative changes

	If you need to make changes to your source code, make the updates in the "asterisk", "app\_rpt", and "asl3-asterisk" directories.  Then, repeat step 4 (update the source), step 5 (build), and step 6 (install/test).

### Experimental Development

The `build-asl3` command usage includes a "-l" option that, for now, should be considered "experimental" due to it's limited testing.
This option changes how the "asterisk", "app\_rpt", and "asl3-asterisk" directories are merged together.
Rather than copying each file to the merged directory the command will, instead, symlink the files back to the source directories.
What this means is that you can make changes in the source directories and not need to re-exec `build-asl3` with the "source" action.

Note: some of the files in the merged directory are patched.  If you are making source code changes to any of these [patched] files then you should not use the "-l" option.

Note: the "-l" option can NOT be used when creating Debian packages.

# BUGS

Report bugs to https://github.com/AllStarLink/ASL3/issues

# COPYRIGHT

Copyright (C) 2024 Allan Nathanson and AllStarLink
under the terms of the AGPL v3.
