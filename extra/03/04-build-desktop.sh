#!/bin/sh

#check if run as root
#[ $UID -eq 0 ] && echo "Don't run this script as root!" && exit 1

#help output
if [ "$1" == "-h" ]
then
	echo "Script to build openbox, open-vm-tools and google-chrome binary deps"
	echo "Usage:"
	echo -e "\t$0 [package]"
	echo -e "\tpackage: First package in list to get installed. This is to be able to continue where you left of before."
	exit 0
fi

#load settings from ~/.lfs-me
[ -f ~/.lfs-me ] && source ~/.lfs-me


install=(
'startup-notification'
'libjpeg-turbo'
'libtiff'
'xmlto'
'giflib'
'imlib2'
'shared-mime-info'
'gdk-pixbuf'
'rxvt-unicode'
'libcroco'
'fribidi'
'pango'
'vala'
'rustc'
'librsvg'
'dmenu'
'atk'
'hicolor-icon-theme'
'gtk+2'
'openbox'
'tint2'
'alsa-lib'
'gstreamer'
'cdparanoia'
'iso-codes'
'libogg'
'libvorbis'
'sdl'
'libtheora'
'gst-plugins-base'
'glu'
'freeglut'
'jasper'
'lcms2'
'libmng'
'libxkbcommon'
'qt'
'lxqt-build-tools'
'qtermwidget'
'qterminal'
'libmspack'
'libsigc++'
'glibmm'
'atkmm'
'cairomm'
'pangomm'
'gtkmm2'
'pyrex'
'libdnet'
'rpcsvc-proto'
'fuse3'
'fuse2'
'at-spi2-core'
'at-spi2-atk'
'gtk+3'
'gtkmm'
'xf86-video-vmware'
'open-vm-tools'
'libusb'
'libgusb'
'libgudev'
'links'
'xdg-utils'
'colord'
'cups'
'google-chrome-beta'
)

mkdir -v pkg

[ -f build-chromium.log ] && rm build-chromium.log
touch build-chromium.log

for package in "${install[@]}"
do
	if [ -z $1 ] || [ $1 == $package ]
	then
		shift "$#" #remove commandline parameters
		echo "BUILDING ${package}"
		lfs-me build "$package" | tee -a build-desktop.log
		[ ! ${PIPESTATUS[0]} -eq 0 ] && echo "Building '$package' failed!" && exit 1
		mv ${package}*.pkg  pkg/
		lfs-me install pkg/${package}*.pkg | tee -a build-desktop.log
		[ ! ${PIPESTATUS[0]} -eq 0 ] && echo "Installing '$package' failed!" && exit 1
	fi
done


