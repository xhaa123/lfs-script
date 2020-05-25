#!/bin/sh
# Override some libraries to avoid incompatibillity
#export LD_PRELOAD='/usr/$LIB/libstdc++.so.6 /usr/$LIB/libgcc_s.so.1 /usr/$LIB/libxcb.so.1 /usr/$LIB/libgpg-error.so'
LIBGL_DRIVERS_PATH='/opt/lib32/dri' exec /usr/lib/steam/steam "$@"
