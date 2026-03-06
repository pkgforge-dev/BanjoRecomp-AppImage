#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm libdecor

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
PRE_BUILD_CMDS='sed -i "/\.desktop\"$/ { s/$/)/; n; d; }; /'231b48ef3b38bb06b4412ec911c13d5938f29b511ea0a814c364182fa112c01b'/ { s/$/)/; n; d; }" ./PKGBUILD'  make-aur-package banjorecomp

# If the application needs to be manually built that has to be done down here

# if you also have to make nightly releases check for DEVEL_RELEASE = 1
#
# if [ "${DEVEL_RELEASE-}" = 1 ]; then
# 	nightly build steps
# else
# 	regular build steps
# fi
