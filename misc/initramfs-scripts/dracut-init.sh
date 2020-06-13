#!/bin/sh
dracut --kernel-image /vmlinuz --force -a "crypt drm" -I "/usr/bin/cryptsetup" --no-kernel
