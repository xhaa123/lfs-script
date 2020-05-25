#!/bin/bash

cp -aR /usr/src/initramfs 	 /usr/src/initramfs-livecd/mnt_init
#cp -a /bin/busybox 		 /usr/src/initramfs-livecd/mnt_init/bin/
mkdir -v /usr/src/initramfs-livecd/mnt_init/boot
echo "31337ecorp-live" > /usr/src/initramfs-livecd/id_label

cat > /usr/src/initramfs-livecd/mnt_init/init << "EOF"
#!/bin/sh

#/bin/busybox --install -s
mount -t proc none /proc
mount -t sysfs none /sys
mount -t devtmpfs none /dev

ARCH=x86_64
LABEL="$(cat /boot/id_label)"

modprobe drm
modprobe i915
modprobe nouveau
modprobe vmwgfx
modprobe amdgpu

###########################
rescue_shell() {
exec sh
}
###########################

overlayMount() {

mkdir -p /mnt/writable
mount -t tmpfs -o rw tmpfs /mnt/writable
mkdir -p /mnt/writable/upper
mkdir -p /mnt/writable/work

D_LOWER="/mnt/system"
D_UPPER="/mnt/writable/upper"
D_WORK="/mnt/writable/work"
OVERLAYFSOPT="lowerdir=${D_LOWER},upperdir=${D_UPPER},workdir=${D_WORK}"

mount -t overlay overlay -o ${OVERLAYFSOPT} ${ROOT} 

}
###########################

mkdir -p /mnt/medium
mkdir -p /mnt/system
mkdir -p /mnt/rootfs

sleep 3

# Search for, and mount the boot medium
LABEL="$(cat /boot/id_label)"
for device in $(ls /dev); do
    [ "${device}" == "console" ] && continue
    [ "${device}" == "null"    ] && continue

    mount -o ro /dev/${device} /mnt/medium 2> /dev/null && \
    if [ "$(cat /mnt/medium/boot/${ARCH}/id_label)" != "${LABEL}" ]; then
        umount /mnt/medium
    else
        DEVICE="${device}"
        break
    fi
done

if [ "${DEVICE}" == "" ]; then
    echo "STOP: Boot medium not found."
    rescue_shell
fi

# Mount the system image
mount -t squashfs -o ro,loop /mnt/medium/boot/${ARCH}/root.sfs /mnt/system || {
    if [ -r /mnt/medium/boot/${ARCH}/root.sfs ]; then
        echo "STOP: Unable to mount system image. The kernel probably lacks"
        echo "      SquashFS support. You may need to recompile it."
    else
        echo "STOP: Unable to mount system image. It seems to be missing."
    fi

    rescue_shell
}

# Define where the new root filesystem will be
ROOT="/mnt/rootfs" # Also needed for /usr/share/live/sec_init.sh

# Select LiveCD mode
overlayMount

# Move current mounts to directories accessible in the new root
cd /mnt
for dir in $(ls -1); do
    if [ "${dir}" != "rootfs" ]; then
        mkdir -p ${ROOT}/mnt/.boot/${dir}
        mount --move /mnt/${dir} ${ROOT}/mnt/.boot/${dir}
    fi
done
cd /

exec switch_root ${ROOT} /sbin/init

EOF
cd /usr/src/initramfs-livecd
cp -v id_label mnt_init/boot/
chmod +x mnt_init/init
pushd mnt_init
find . -print0 | cpio --null -ov --format=newc | gzip -9 > ../initramfs-livecd.gz
popd
rm -rf mnt_init

mount -o loop,ro /iso-build/rootfs-ecorplive.img /mnt/iso
mksquashfs /mnt/iso/ root.sfs -comp xz
umount /mnt/iso

mkdir -p live/boot/x86_64
#cp -R /boot/* live

mv -v root.sfs live/boot/x86_64
mv -v id_label live/boot/x86_64
mv -v initramfs-livecd.gz live/boot/x86_64/initram.fs

#mount /dev/sdc1 /mnt/lfs
#cp -v live/boot/x86_64/initram.fs /mnt/lfs
#cp -v live/boot/x86_64/root.sfs /mnt/lfs/boot/x86_64/
#cp /usr/src/linux-$(uname -r)/arch/x86/boot/bzImage /mnt/lfs/vmlinuz-$(uname -r)
#umount /mnt/lfs

xorriso -as mkisofs \
       -iso-level 3 \
       -full-iso9660-filenames \
       -volid "ecorp-linux" \
       -eltorito-boot isolinux/isolinux.bin \
       -eltorito-catalog isolinux/boot.cat \
       -no-emul-boot -boot-load-size 4 -boot-info-table \
       -isohybrid-mbr live/isolinux/isohdpfx.bin \
       -eltorito-alt-boot \
       -e EFI/ecorp/efiroot.img \
       -no-emul-boot -isohybrid-gpt-basdat \
       -output ecorp-live.iso \
       live

echo "done"
