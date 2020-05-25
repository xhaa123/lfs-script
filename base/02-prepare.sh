#run this after chroot.sh
echo "fix ssl error with wget"
mknod /dev/random c 1 8
mkdir -pv /bin
ln -sv /tools/bin/bash /bin/bash
ln -sv /bin/bash /bin/sh
ln -sv /tools/bin/env /bin/env
cat > ~/.bashrc << "EOF"
export CFLAGS="-pipe -march=native -mtune=native -O3"
export CXXFLAGS="${CFLAGS}"
export MAKEOPTS="-j6"
export MAKEFLAGS="-j6"
alias ls='ls --color'
EOF
cp ../misc/config_files/lfsmerc ~/.lfs-me
mkdir -pv /var/sources
mv /tools/var/sources/* /var/sources/
echo "Now Run source ~/.bashrc"
