#!/bin/bash
wpa_supplicant -iwlan0 -B -c/etc/wpa_supplicant/default.conf
dhcpcd

