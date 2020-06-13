#!/bin/sh

#build an initramfs with dracut and extract it to /usr/src/initramfs

export KERNVER=5.7.1-sauzeros
export ROOTFSIMAGE=rootfs-sauzeros.img

#copy modules to initramfs
rm -rf /usr/src/initramfs/lib/modules/*
cp -a /lib/modules/$KERNVER /usr/src/initramfs/lib/modules/

#copy modules to rootfs
mount /usr/src/iso-build/$ROOTFSIMAGE /mnt/iso
rm -rf /mnt/iso/lib/modules/*
cp -a /lib/modules/$KERNVER /mnt/iso/lib/modules/
umount /mnt/iso

mkdir -pv /usr/src/initramfs-livecd/mnt_init
cp -aR /usr/src/initramfs/* 	 /usr/src/initramfs-livecd/mnt_init
cp -a /bin/busybox 		 /usr/src/initramfs-livecd/mnt_init/bin/
mkdir -v /usr/src/initramfs-livecd/mnt_init/boot
echo "sauzeros-live" > /usr/src/initramfs-livecd/id_label

cat > /usr/src/initramfs-livecd/mnt_init/init << "EOF"
#!/bin/sh

/bin/busybox --install -s
mount -t proc none /proc
mount -t sysfs none /sys
mount -t devtmpfs none /dev

ARCH=x86_64
LABEL="$(cat /boot/id_label)"


#load driver early for miix-sg80
modprobe pwm-lpss
modprobe pwm-lpss-platform
modprobe drm
modprobe i915

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
for device in $(ls /dev/); do

    [ "${device}" == "console" ]  && continue
    [ "${device}" == "null"    ]  && continue
    [ "${device}" == "snapshot" ] && continue
    [ "${device}" == "port" ]     && continue
    [ "${device}" == "random" ]   && continue
    [[ "${device}" == tty* ]]     && continue
    [[ "${device}" == loop* ]]    && continue

    echo $device && mount -o ro /dev/${device} /mnt/medium 2> /dev/null && \
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
find . -print0 | cpio --null -ov --format=newc > ../initramfs-livecd
popd
rm -rf mnt_init

lz4 -flv initramfs-livecd

mount -o loop,ro /usr/src/iso-build/$ROOTFSIMAGE /mnt/iso
mksquashfs /mnt/iso/ root.sfs -comp xz
umount /mnt/iso

mkdir -p live/boot/x86_64

cp /usr/src/linux-$KERNVER/arch/x86/boot/bzImage /usr/src/initramfs-livecd/

mv -v root.sfs live/boot/x86_64
mv -v id_label live/boot/x86_64
cp -v initramfs-livecd.lz4 live/boot/x86_64/initram.fs
cp -v bzImage live/boot/x86_64/vmlinuz-sauzeros
mount live/EFI/sauzeros/efiboot.img /mnt/iso
cp -v initramfs-livecd.lz4 /mnt/iso/initram.fs
cp -v bzImage /mnt/iso/vmlinuz-sauzeros
umount /mnt/iso
rm -v initramfs-livecd*
echo "all done"
