#!/bin/bash
set -e

#get DPKG_BUILDOPTS from env var or use default
OPTS=${DPKG_BUILDOPTS:-"-b -uc -us"}

if [ -f /etc/os-release ] ; then
  OS_CODENAME=$(cat /etc/os-release | grep "^VERSION_CODENAME=" | sed 's/VERSION_CODENAME=\(.*\)/\1/g')
elif [ command -v lsb_release ] ; then
  OS_CODENAME=$(lsb_release -a 2>/dev/null | grep "^Codename:" | sed 's/^Codename:\s*\(.*\)/\1/g')
elif [ command -v hostnamectl ] ; then
  OS_CODENAME=$(hostnamectl | grep "Operating System: " | sed 's/.*Operating System: [^(]*(\([^)]*\))/\1/g')
else
  OS_CODENAME=unknown
fi

echo "OS_CODENAME: ${OS_CODENAME}"

cd /build
gh repo clone AllStarLink/app_rpt
gh repo clone AllStarLink/ASL3

case $OS_CODENAME in
	bullseye)
		echo 11 > asl3-asterisk/debian/compat
	;;
	bookworm)
		echo 12 > asl3-asterisk/debian/compat
	;;
	*)
		echo 13 > asl3-asterisk/debian/compat
	;;
esac

export EMAIL="AllStarLink <autobuild@allstarlink.org>"
asl3-asterisk/build-tree -a $


[ ! -d _debs ] && mkdir _debs
rm -f _debs/*
cp *.deb _debs/
gh release upload -R AllStarLink/asl3-asterisk ghr-test _debs/*.deb
