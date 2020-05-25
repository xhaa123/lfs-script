#!/bin/bash
cd /usr/src/initramfs-livecd/

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

cp -v ecorp-live.iso /mnt/mega/Tmp

echo "done"
