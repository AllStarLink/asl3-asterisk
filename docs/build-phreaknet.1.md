
# Source-Based Installation (using phreaknet)

Source install is for developers or users who need to install AllStarLink 3
on unsupported hardware or operating systems. Installing ASL from source
code is primarily for developers.  Doing so will require you to download,
compile, and install multiple projects.  You will also need to be very
comfortable using various development tools and the Linux CLI.

The following instructions are for building ONLY Asterisk with ASL's app_rpt.

- The install does not include any helpers, Allmon3, asl3-menu, asl3-nodelist, etc.
- Installs and runs Asterisk as "root" (this is, in general, bad)

Note: All of the commands below should be executed as the "root" user.

## Install build dependencies

```bash
apt install git libsystemd-dev libtonezone-dev
```

## Install phreaknet.sh script
The phreaknet script is used to download, patch, and compile Asterisk and DAHDI.  You should install the script with the following commands :

```bash
cd /usr/src
wget https://docs.phreaknet.org/script/phreaknet.sh
chmod +x phreaknet.sh
./phreaknet.sh make
```

Once installed, you can keep the script updated with :

```bash
phreaknet update
```

## Install Asterisk 22.x.x LTS

The following `phreaknet install` comamand uses the following options to compile, patch, and install Asterisk and DAHDI.

 - Use --alsa to add ALSA support to the build system (required for building `chan_simpleusb` and `chan_usbradio`)
 - Use -b to enable getting backtraces
 - Use -d to install DAHDI
 - Use -f to force an install or config
 - Use -v to install the latest of the major version specified, 22 in this case

```
phreaknet install --alsa -b -d -f -v 22
```

When the command has finished your system should have Asterisk running but **without app_rpt**.  You can use the following command as a quick check :

```bash
asterisk -rx "core show version"
```

## Clone ASL3 repo

```bash
cd /usr/src
git clone https://github.com/AllStarLink/app_rpt.git
```

## Install Asterisk w/ASL3

This script does a git pull of app_rpt, merges the source with Asterisk, and compiles the branch you are on.

```bash
cd app_rpt
./rpt_install.sh
```

## Install ASL3 configuration files

This adds the ASL3 configuration files to the full set of Asterisk configuration files.  The ASL3 `modules.conf` limits what actually runs.

```bash
cp /usr/src/app_rpt/configs/rpt/* /etc/asterisk
```

## Restart Asterisk

```bash
systemctl stop asterisk
systemctl start asterisk
```

After restarting Asterisk (or rebooting the system) you should now have Asterisk with ASL3 installed.  You can use the following command as a quick check :

```bash
asterisk -rx "rpt localnodes"
```
You should see node 1999.
