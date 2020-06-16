#!/bin/sh -e

export LFS=/mnt/lfs

echo "run this as root"
chown -R root:root $LFS/tools
mkdir -pv $LFS/{dev,etc/ssl,proc,sys,repo,run,usr/bin}
mknod -m 600 $LFS/dev/console c 5 1
mknod -m 666 $LFS/dev/null c 1 3
cp misc/kissd-chroot /tools/bin/
cp /etc/ssl/cert.pem $LFS/etc/ssl/
chmod 0755 $LFS/etc
pushd $LFS
ln -s usr/bin bin
ln -s /tools/bin/bash bin/sh
popd
pushd $LFS/repo

echo "cloning repos with git"
git clone https://github.com/kisslinux/repo kiss
git clone https://github.com/kisslinux/community
git clone https://github.com/fanboimsft/kissD

echo "all done, use /tools/bin/kissd-chroot to chroot and build system with kiss package manager"
