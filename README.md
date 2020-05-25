# lfs-script
collection of build scripts for LinuxFromScratch to be used with the lfs-me package manager

https://github.com/FSMaxB/lfs-me

https://linuxfromscratch.org

This is an easy way to setup a LFS/BLFS system that will play nicely with vmware workstation, preferably with EFI boot 
enabled. 

quick start:

1. boot a live iso to use as install media
2. prepare partition for installation and mount to /mnt/lfs
3. clone repo: git clone https://github.com/fanboimsft/lfs-script
4. toolchain: run scripts in toolchain directory (01 to 04), if fakeroot fails then 
compile and install it manually to /tools (cflags and makeflags can be adjust in 02 script)
5. base system: run scripts in base (01 to 03, clfags and makeflags can be adjusted in 02 script) 
   this will compile and install a LFS systemd version
6. compile kernel (vmware kernel config available in misc directory)
7. install bootloader, for EFI mode 'bootctl install' the configure entry in /boot/loader
8. 07 script will configure basic system settings
9. run scripts in extra (01 to 04 will build X, open-vm-tools and required deps for binary google-chrome browser). building 
X requires some manual steps. for xorg-apps, xorg-font, xorg-libs run the .sh script in subdir.
