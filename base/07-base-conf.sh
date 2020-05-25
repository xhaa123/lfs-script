#! /bin/bash
echo "basic dhcp networkd config"
cat > /etc/systemd/network/10-dhcp.network << "EOF"
[Match]
Name=eth0

[Network]
DHCP=ipv4

[DHCP]
UseDomains=true
EOF

#echo "resolvd symbolic link to /etc/resolv.conf"
#ln -sfv /run/systemd/resolve/resolv.conf /etc/resolv.conf
echo "creating /etc/resolv.conf"
cat > /etc/resolv.conf << "EOF"
nameserver 1.1.1.1

EOF

echo "enter hostname"
read hostname;

echo $hostname > /etc/hostname

echo "creating /etc/hosts"

cat > /etc/hosts << "EOF"

127.0.0.1 localhost localhost.localdomain

EOF

echo "creating /etc/locale.conf"

cat > /etc/locale.conf << "EOF"

LANG=en_US.UTF-8

EOF

echo "creating /etc/inputrc"

cat > /etc/inputrc << "EOF"

set horizontal-scroll-mode Off
set meta-flag On
set input-meta On
set convert-meta Off
set output-meta On
set bell-style visible

"\eOd": backward-word
"\eOc": forward-word

"\e[1~": beginning-of-line
"\e[4~": end-of-line
"\e[5~": beginning-of-history
"\e[6~": end-of-history
"\e[3~": delete-char
"\e[2~": quoted-insert

"\eOH": beginning-of-line
"\eOF": end-of-line

"\e[H": beginiing-of-line
"\e[F": end-of-line

EOF

echo "creating /etc/shells"

cat > /etc/shells << "EOF"

/bin/sh
/bin/bash

EOF

echo "installing systemd-boot to /boot"
bootctl --path=/boot install

echo "creating default systemd-boot entry"

cat > /boot/loader/entries/ecorp.conf << "EOF"

title ecorp-linux
linux /vmlinuz
options root=/dev/sda2 rw
EOF

