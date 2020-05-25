#!/bin/sh

#check if run as root
#[ $UID -eq 0 ] && echo "Don't run this script as root!" && exit 1

#help output
if [ "$1" == "-h" ]
then
	echo "Script to build the BLFS base packages"
	echo "Usage:"
	echo -e "\t$0 [package]"
	echo -e "\tpackage: First package in list to get installed. This is to be able to continue where you left of before."
	exit 0
fi

#load settings from ~/.lfs-me
[ -f ~/.lfs-me ] && source ~/.lfs-me


install=(
'pcre2'
'openjdk-bin'
'apache-ant'
'dbus'
'gnutls'
'gtk+3'
'gtkmm2'
'imagemagick'
'libva'
'intel-vaapi-driver'
'libgusb'
'libinput'
'lua'
'nasm'
'pycairo'
'vala'
'wayland-protocols'
'mesa'
'qt'
)

mkdir -v updates

[ -f build-updates.log ] && rm build-updates.log
touch build-updates.log

for package in "${install[@]}"
do
	if [ -z $1 ] || [ $1 == $package ]
	then
		shift "$#" #remove commandline parameters
		echo "BUILDING ${package}"
		lfs-me build "$package"  | tee -a build-base.log
		[ ! ${PIPESTATUS[0]} -eq 0 ] && echo "Building '$package' failed!" && exit 1
		mv ${package}*.pkg  updates/
	fi
done
