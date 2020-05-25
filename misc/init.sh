#!/bin/bash
mkdir -pv /usr/src/initramfs/{bin,dev,etc,lib,lib64,mnt/root,proc,root,sbin,sys}
cp -a /bin/busybox /usr/src/initramfs/bin/
cat > /usr/src/initramfs/init << "EOF"
#!/bin/busybox sh

/bin/busybox --install -s
mount -t proc none /proc
mount -t sysfs none /sys
mount -t devtmpfs none /dev

exec /bin/sh

EOF

chmod +x /usr/src/initramfs/init
cd /usr/src/initramfs
find . -print0 | cpio --null -ov --format=newc | gzip -9 > /boot/custom-initramfs.gz
echo "initramfs written to /boot"
