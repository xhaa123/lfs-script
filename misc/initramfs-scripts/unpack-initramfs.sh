#!/bin/sh
zcat $1 | cpio -idmv
