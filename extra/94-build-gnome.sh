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
'accountsservice'
'gpgme'
'gmime'
'totem-pl-parser'
'pcre2'
'vte'
'yelp-xsl'
'geocode-glib'
'gjs'
'gnome-autoar'
'libseccomp'
'gnome-desktop'
'gnome-menus'
'telepathy-glib'
'cdparanoia'
'gst-plugins-base'
'ruby'
'aspell'
'enchant'
'libdaemon'
'libglade'
'dbus-python'
'avahi'
'geoclue'
'gnome-video-effects'
'grilo'
#'gtkhtml'
'cogl'
'clutter'
'clutter-gtk'
'libchamplain'
'liboauth'
'uhttpsmock'
'libdvdread'
'libdvdnav'
'soundtouch'
'faac'
'faad2'
'libmpeg2'
'mpg123'
'neon'
'libmng'
'qt'
'v4l-utils'
'aalib'
'imagemagick'
'liba52'
'libmad'
'speexdsp'
'speex'
'xine-lib'
'opencv'
'openjpeg'
'gst-plugins-bad'
'webkitgtk'
'gnome-online-accounts'
'libgdata'
'libgee'
'libgtop'
'libgweather'
'libpeas'
'startup-notification'
'libwnck'
'cyrus-sasl'
'openldap'
'evolution-data-server'
'telepathy-logger'
'telepathy-mission-control'
'libxklavier'
'caribou'
'dconf'
'dconf-editor'
'gnome-backgrounds'
'libatasmart'
'gptfdisk'
'fuse'
'ntfs-3g'
'parted'
'volume_key'
'libbytesize'
'libblockdev'
'udisks'
'libcddb'
'libcdio'
'Parse-Yapp'
'talloc'
'rpcsvc-proto'
'samba'
'libcdio-paranoia'
'libplist'
'libusbmuxd'
'libimobiledevice'
'usbmuxd'
'gvfs'
'boost'
'exempi'
'tracker'
'exiv2'
'gexiv2'
'nautilus'
'zenity'
'gnome-keyring'
'libwacom'
'xf86-input-wacom'
'gnome-settings-daemon'
'libpwquality'
'colord-gtk'
'gcab'
'yaml'
'snowball'
'appstream-glib'
'gnome-color-manager'
'ibus'
'libdv'
'taglib'
'gst-plugins-good'
'clutter-gst'
'cheese'
'gnome-control-center'
'pipewire'
'mutter'
'gdm'
'adwaita-icon-theme'
'gnome-themes-standard'
'libsass'
'sassc'
'gnome-shell'
'gnome-shell-extensions'
'gnome-session'
'yelp'
'notification-daemon'
'gnome-terminal'
'sound-theme-freedesktop'
'XML-SAX-Expat'
'XML-LibXML'
'Tie-IxHash'
'XML-Simple'
'icon-naming-utils'
'gnome-icon-theme'
'gnome-icon-theme-extras'
'gnome-icon-theme-symbolic'
)

mkdir -v pkg

[ -f build-X11.log ] && rm build-gnome.log
touch build-gnome.log

for package in "${install[@]}"
do
	if [ -z $1 ] || [ $1 == $package ]
	then
		shift "$#" #remove commandline parameters
		echo "BUILDING ${package}"
		lfs-me build "$package"  | tee -a build-updates.log
		[ ! ${PIPESTATUS[0]} -eq 0 ] && echo "Building '$package' failed!" && exit 1
		mv ${package}*.pkg  pkg/
		lfs-me install pkg/${package}*.pkg | tee -a build-gnome.log
		[ ! ${PIPESTATUS[0]} -eq 0 ] && echo "Installing '$package' failed!" && exit 1
	fi
done
