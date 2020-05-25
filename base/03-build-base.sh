#!/tools/bin/bash

#check if run as root
#[ $UID -eq 0 ] && echo "Don't run this script as root!" && exit 1

#help output
if [ "$1" == "-h" ]
then
	echo "Script to build the LFS systemd base"
	echo "Usage:"
	echo -e "\t$0 [package]"
	echo -e "\tpackage: First package in list to get installed. This is to be able to continue where you left of before."
	exit 0
fi

#load settings from ~/.lfs-me
[ -f ~/.lfs-me ] && source ~/.lfs-me


install=(
	'filesystem-0'
	'linux-headers'
	'man-pages'
	'glibc'
	'tzdata'
	'toolchain-adjustment'
	'zlib'
	'file'
	'binutils'
	'gmp'
	'mpfr'
	'mpc'
	'gcc'
	'bzip2'
	'pkg-config'
	'ncurses'
	'attr'
	'acl'
	'libcap'
	'sed'
	'shadow'
	'psmisc'
	'iana-etc'
	'm4'
	'bison'
	'flex'
	'grep'
	'readline'
	'bash'
	'bc'
	'libtool'
	'gdbm'
	'gperf'
	'expat'
	'inetutils'
	'perl'
	'XML-Parser'
	'intltool'
	'autoconf'
	'automake'
	'xz'
	'kmod'
	'gettext'
	'libelf'
	'libffi'
	'openssl'
	'Python3'
	'ninja'
	'meson'
	'unzip'
	'gnu-efi'
	'less'
	'gzip'
	'findutils'
	'texinfo'
	'e2fsprogs'
	'coreutils'
	'Check'
	'diffutils'
	'gawk'
	'groff'
	'iproute2'
	'kbd'
	'libpipeline'
	'make'
	'patch'
	'systemd'
	'dbus'
	'procps-ng'
	'util-linux'
	'man-db'
	'tar'
	'popt'
	'ca-certificates'
	'rsync'
	'curl'
	'lzip'
	'wget'
	'nano'
	'fakeroot'
	'git'
	'lfs-me'
	'pciutils'
	'efivar'
	'efibootmgr'
	'cpio'
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
		lfs-me build "$package" --no-cert-check | tee -a build-base.log
		[ ! ${PIPESTATUS[0]} -eq 0 ] && echo "Building '$package' failed!" && exit 1
		mv ${package}*.pkg  pkg/
		lfs-me install pkg/${package}*.pkg | tee -a build-base.log
		[ ! ${PIPESTATUS[0]} -eq 0 ] && echo "Installing '$package' failed!" && exit 1
	fi
done
