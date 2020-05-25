#!/bin/bash
dd if=/dev/zero of=/iso-build/rootfs-ecorplive.img bs=1G seek=5 count=0
mkfs.f2fs /iso-build/rootfs-ecorplive.img
