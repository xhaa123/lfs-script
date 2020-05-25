#!/bin/sh

#check if run as root
#[ $UID -eq 0 ] && echo "Don't run this script as root!" && exit 1

#help output
if [ "$1" == "-h" ]
then
	echo "Script to build Chromium"
	echo "Usage:"
	echo -e "\t$0 [package]"
	echo -e "\tpackage: First package in list to get installed. This is to be able to continue where you left of before."
	exit 0
fi

#load settings from ~/.lfs-me
[ -f ~/.lfs-me ] && source ~/.lfs-me


install=(
	'glu'
	'freeglut'
	'libjpeg-turbo'
	'libtiff'
	'lcms2'
	'libusb'
	'vala'
	'python2-libxml2'
	'six'
	'itstool'
	'gtk-doc'
	'libgusb'
	'libgudev'
	'bash-completion'
	'colord'
	'xmlto'
	'gpm'
	'links'
	'xdg-utils'
	'cups'
	'desktop-file-utils'
	'atk'
	'jasper'
	'shared-mime-info'
	'gdk-pixbuf'
	'hicolor-icon-theme'
	'fribidi'
	'pango'
	'gtk+2'
	'krb5'
	'usbutils'
	'libogg'
	'nasm'
	'flac'
	'libexif'
	'libsecret'
	'dbus-glib'
	'gconf'
	'at-spi2-core'
	'at-spi2-atk'
	'json-glib'
	'libxkbcommon'
	'gsettings-desktop-schemas'
	'glib-networking'
	'libsoup'
	'rest'
	'libcroco'
	'giflib'
	'imlib2'
	'rustc'
	'librsvg'
	'gtk+3'
	'libsndfile'
	'alsa-lib'
	'pulseaudio'
	'alsa-plugins'
	'alsa-utils'
	'libsigc++'
	'glibmm'
	'cairomm'
	'pangomm'
	'atkmm'
	'gtkmm'
	'libvorbis'
	'gstreamer'
	'libcanberra'
	'pavucontrol'
	'c-ares'
	'node-js'
	'Module-Build'
	'File-Which'
	'IPC-System-Simple'
	'File-BaseDir'
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
		lfs-me build "$package" | tee -a build-chromium.log
		[ ! ${PIPESTATUS[0]} -eq 0 ] && echo "Building '$package' failed!" && exit 1
		mv ${package}*.pkg  pkg/
		lfs-me install pkg/${package}*.pkg | tee -a build-chromium.log
		[ ! ${PIPESTATUS[0]} -eq 0 ] && echo "Installing '$package' failed!" && exit 1
	fi
done


