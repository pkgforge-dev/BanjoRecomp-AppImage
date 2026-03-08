#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
	gtk3	       \
	libdecor  	   \
	sdl2	 	   \
	vulkan-headers

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package

# If the application needs to be manually built that has to be done down here
echo "Getting app..."
echo "---------------------------------------------------------------"
case "$ARCH" in # they use X64 and ARM64 for the zip links
	x86_64)  zip_arch=Linux-X64;;
	aarch64) zip_arch=Linux-ARM64;;
esac
ZIP_LINK=$(wget -qO- https://api.github.com/repos/BanjoRecomp/BanjoRecomp/releases \
      | sed 's/[()",{} ]/\n/g' | grep "https.*BanjoRecompiled.*$zip_arch\.zip" | head -n 1)
echo "$ZIP_LINK" | grep -oP 'v\K[\d.]+' > ~/version
if ! wget --retry-connrefused --tries=30 "$ZIP_LINK" -O /tmp/app.zip 2>/tmp/download.log; then
	cat /tmp/download.log
	exit 1
fi

mkdir -p ./AppDir/bin
mkdir -p ./BanjoRecomp
bsdtar -xvf /tmp/app.zip -C ./BanjoRecomp
mv -v ./BanjoRecomp/BanjoRecompiled ./AppDir/bin
mv -v ./BanjoRecomp/assets ./AppDir/bin
wget -O ./AppDir/bin/recompcontrollerdb.txt https://raw.githubusercontent.com/mdqinc/SDL_GameControllerDB/master/gamecontrollerdb.txt
