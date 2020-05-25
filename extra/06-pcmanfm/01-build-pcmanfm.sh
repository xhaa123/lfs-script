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
'libatasmart'
'gptfdisk'
'ntfs-3g'
'pcre2'
'libbytesize'
'gpgme'
'volume_key'
'parted'
'libblockdev'
'udisks'
'libcddb'
'libcdio'
'libcdio-paranoia'
'libplist'
'libusbmuxd'
'libimobiledevice'
'usbmuxd'
'libsecret'
'libical'
'bluez'
'dbus-glib'
'gcr'
'Module-Build'
'File-Which'
'IPC-System-Simple'
'Parse-Yapp'
'samba'
'talloc'
'cifs-utils'
'gvfs'
'gtk-doc'
'menu-cache'
'libexif'
'libfm'
'lxmenu-data'
'pcmanfm'

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


