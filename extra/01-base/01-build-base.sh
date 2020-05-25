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
	'bash-files'
	'lsb-release'
	'nettle'
	'libtasn1'
	'nspr'
	'sqlite'
	'tcl'
	'sharutils'
	'berkeley-db'
	'Python2'
	'libxml2'
	'sgml-common'
	'docbook-xml'
	'docbook-xsl-nons'
	'libgpg-error'
	'pth'
	'libgcrypt'
	'libxslt'
	'nss'
	'p11-kit'
	'libunistring'
	'gnutls'
	'libtirpc'
	'Linux-PAM'
	'openssh'
	'sudo'
	'pcre'
	'glib'
	'which'
	'gobject-introspection'
	'zip'
	'autoconf-firefox'
	'icu'
	'yasm'
	'libidn'
	'libaio'
	'lvm2'
	'json-c'
	'cryptsetup'
	'libpng'
	'slang'
	'mc'
	'htop'
	'libevent'
	'tmux'
	'neofetch'
	'lftp'
)

mkdir -v pkg

[ -f build-base.log ] && rm build-base.log
touch build-base.log

for package in "${install[@]}"
do
	if [ -z $1 ] || [ $1 == $package ]
	then
		shift "$#" #remove commandline parameters
		echo "BUILDING ${package}"
		lfs-me build "$package"  | tee -a build-base.log
		[ ! ${PIPESTATUS[0]} -eq 0 ] && echo "Building '$package' failed!" && exit 1
		mv ${package}*.pkg  pkg/
		lfs-me install pkg/${package}*.pkg | tee -a build-base.log
		[ ! ${PIPESTATUS[0]} -eq 0 ] && echo "Installing '$package' failed!" && exit 1
	fi
done

install2=(
	'shadow'
	'systemd'
)

for package in "${install2[@]}"
do
        if [ -z $1 ] || [ $1 == $package ]
        then
                shift "$#" #remove commandline parameters
                echo "BUILDING ${package}"
                lfs-me build "$package"  | tee -a build-X11.log
                [ ! ${PIPESTATUS[0]} -eq 0 ] && echo "Building '$package' failed!" && exit 1
                mv ${package}*.pkg  pkg/
 		lfs-me remove "$package"
                lfs-me install pkg/${package}*.pkg | tee -a build-X11.log
                [ ! ${PIPESTATUS[0]} -eq 0 ] && echo "Installing '$package' failed!" && exit 1
        fi
done

echo "Setting locale to US, won't work if still in chroot"
localectl set-locale LANG=en_US.utf8
localectl set-keymap us
