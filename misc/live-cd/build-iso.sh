#!/bin/sh
cd /usr/src/initramfs-livecd/

xorriso -as mkisofs \
       -iso-level 3 \
       -full-iso9660-filenames \
       -volid "sauzeros" \
       -eltorito-boot isolinux/isolinux.bin \
       -eltorito-catalog isolinux/boot.cat \
       -no-emul-boot -boot-load-size 4 -boot-info-table \
       -isohybrid-mbr live/isolinux/isohdpfx.bin \
       -eltorito-alt-boot \
       -e EFI/sauzeros/efiboot.img \
       -no-emul-boot -isohybrid-gpt-basdat \
       -output sauzeros-live.iso \
	live

echo "done"
