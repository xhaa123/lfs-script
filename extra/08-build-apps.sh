#!/bin/sh

#help output
if [ "$1" == "-h" ]
then
	echo "Script to update gnome and dependancies"
	echo "Usage:"
	echo -e "\t$0 [package]"
	echo -e "\tpackage: First package in list to get installed. This is to be able to continue where you left of before."
	exit 0
fi
[ -z $XORG_PREFIX ] && echo "xorg prefix not set - install xorg-build-environment first" && exit 1
[ -z $XORG_CONFIG ] && echo "xorg congig not set - install xorg-build-environment first" && exit 1
#load settings from ~/.lfs-me
[ -f ~/.lfs-me ] && source ~/.lfs-me


install=(
'exfat-nofuse'
'poppler'
'evince'
'eog'
'gtksourceview'
'gedit'
'unrar'
'cpio'
'file-roller'
'p7zip'
'xarchiver'
'wxgtk'
'libfilezilla'
'filezilla'
'extra-cmake-modules'
'libgnome-keyring'
'qtkeychain'
'veracrypt'
'pidgin'
'freerdp'
'openal'
'libostree'
'flatpak'
'neofetch'
'giblib'
'scrot'
'lua'
'uchardet'
'luajit'
'mpv'
'python2-certifi'
'python2-urllib3'
'python2-idna'
'python2-chardet'
'python2-requests'
'oniguruma'
'jq'
'chrome-gnome-shell'
'gnome-tweaks'
'gnome-system-monitor'
'libsodium'
'argon2'
'keepassxc'
)

mkdir -v pkg

[ -f build-apps.log ] && rm build-apps.log
touch build-apps.log

for package in "${install[@]}"
do
	if [ -z $1 ] || [ $1 == $package ]
	then
		shift "$#" #remove commandline parameters
		echo "BUILDING ${package}"
		lfs-me build "$package"  | tee -a build-apps.log
		[ ! ${PIPESTATUS[0]} -eq 0 ] && echo "Building '$package' failed!" && exit 1
		mv ${package}*.pkg  pkg/
		lfs-me install pkg/${package}*.pkg | tee -a build-apps.log
		[ ! ${PIPESTATUS[0]} -eq 0 ] && echo "Installing '$package' failed!" && exit 1
	fi
done
