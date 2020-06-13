#!/bin/sh
mkdir -pv /usr/src/initramfs/{bin,dev,etc,lib,lib64,mnt/root,proc,root,sbin,sys}
cp -a /bin/busybox /usr/src/initramfs/bin/
cat > /usr/src/initramfs/init << "EOF"
#!/bin/busybox sh

/bin/busybox --install -s
mount -t proc none /proc
mount -t sysfs none /sys
mount -t devtmpfs none /dev

modprobe drm
modprobe i915

cryptsetup luksOpen /dev/mmcblk0p2 root
lvm lvchange -a y ecorp/root
lvm lvchange -a y ecorp/swap
lvm vgmknodes
mount /dev/mapper/ecorp-root /mnt/root
swapon /dev/mapper/ecorp-swap

rescue_shell() {
exec sh
}

exec switch_root /mnt/root /sbin/init

EOF

chmod +x /usr/src/initramfs/init
cd /usr/src/initramfs
find . -print0 | cpio --null -ov --format=newc | gzip -9 > /boot/custom-initramfs.gz
echo "initramfs written to /boot"
