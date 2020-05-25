#!/bin/bash
cat > /boot/grub/grub.cfg << "EOF"
#Begin /boot/grub/grub.cfg
set default=0
set timeout=5

insmod ext2
set root=(hd0,3)

menuentry "eCOPR Linux" {
	/boot/vmlinuz root=/dev/sda3 ro

}

EOF

