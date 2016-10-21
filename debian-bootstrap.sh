#!/bin/sh

#https://wiki.debian.org/Arm64Qemu
#https://wiki.debian.org/Arm64PortANFUList
#https://wiki.debian.org/Arm64Port/raringbootstrap
#https://wiki.debian.org/Arm64Port
#https://wiki.debian.org/ArchiveQualification/arm64

#https://packages.debian.org/sid/android-permissions
#Android's system/core/include/private/android_filesystem_config.h


#HOST
apt-get update
apt-get install qemu qemu-user-static binfmt-support debootstrap


O="GNULinux" D="debian" R="sid" A="arm64" P="/srv/nfs/$O-$D-$R-$A"; mkdir -p $P; cd $P
#O="GNULinux" D="debian" R="jessie" A="arm64" P="/srv/nfs/$O-$D-$R-$A"; mkdir -p $P; cd $P
#O="GNULinux" D="debian" R="sid" A="armhf" P="/srv/nfs/$O-$D-$R-$A"; mkdir -p $P; cd $P
#O="GNULinux" D="debian" R="jessie" A="armhf" P="/srv/nfs/$O-$D-$R-$A"; mkdir -p $P; cd $P
#O="GNULinux" D="debian" R="sid" A="x86_64" P="/srv/nfs/$O-$D-$R-$A"; mkdir -p $P; cd $P
#O="GNULinux" D="debian" R="jessie" A="x86_64" P="/srv/nfs/$O-$D-$R-$A"; mkdir -p $P; cd $P


#qemu-debootstrap
# --keyring=/usr/share/keyrings/debian-archive-keyring.gpg    #USELESS
# --include=android-permissions

qemu-debootstrap --arch=$A $R $P http://mirrors.kernel.org/debian | tee .log
#qemu-debootstrap --arch=$A $R $P http://mirrors.kernel.org/debian --download-only

#debootstrap --arch=$A $R $P http://mirrors.kernel.org/debian | tee .log


echo "$O-$D-$R-$A" > $P/etc/hostname
mkdir -p .deb
mv var/cache/apt/archives/*.deb .deb/

mount -t proc none proc/; \
mount -t sysfs none sys/; \
mount -t devtmpfs devtmpfs dev/; \
mount -t devpts devpts dev/pts/; \
mount -t tmpfs none run/; \
mount -t tmpfs none tmp/; \
mount --bind .deb var/cache/apt/archives/
# umount var/cache/apt/archives/ tmp/ run/ dev/pts/ dev/ sys/ proc/
env -i HOME=$HOME PATH=$PATH TERM=$TERM /usr/sbin/chroot . /bin/sh -c "/bin/bash -l -i"

exit 0


#TARGET #chroot

#useradd -u 1000 -U -G audio,video -s /bin/bash -m user
useradd -u 1000 -U -s /bin/bash -m user
chmod 700 /home/user

passwd root << eof
bXlyb290Cg
bXlyb290Cg
eof

passwd user << eof
bXl1c2VyCg
bXl1c2VyCg
eof

ln -sfv /usr/share/zoneinfo/UTC /etc/localtime
printf "0.0 0 0.0\n0\nUTC\n" > /etc/adjtime
sed -i "/UTC=/s+no+yes+" /etc/default/rcS
echo "Etc/UTC" > /etc/timezone

cat > /etc/fstab << eof
# /etc/fstab: static file system information.
#
# Use 'blkid' to print the universally unique identifier for a
# device; this may be used with UUID= as a more robust way to name devices
# that works even if disks are added and removed. See fstab(5).
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
proc            /proc           proc    defaults        0       0
/dev/root       /               auto    defaults,errors=remount-ro 0       0
eof

ln -sfv /proc/self/mounts /etc/mtab

cat > /etc/hosts << eof
127.0.0.1 localhost

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
eof

cat > /etc/profile.d/hist.sh << eof
export HISTFILESIZE=0
export HISTSIZE=1024
eof

#sid
cat > /etc/apt/sources.list << eof
deb http://mirrors.kernel.org/debian sid main
deb-src http://mirrors.kernel.org/debian sid main

#deb http://httpredir.debian.org/debian sid main
#deb-src http://httpredir.debian.org/debian sid main

#deb http://ftp.debian.org/debian sid main
#deb-src http://ftp.debian.org/debian sid main
eof

apt-get update

#jessie
cat > /etc/apt/sources.list << eof
deb http://mirrors.kernel.org/debian jessie main
deb-src http://mirrors.kernel.org/debian jessie main

#deb http://httpredir.debian.org/debian jessie main
#deb-src http://httpredir.debian.org/debian jessie main

#deb http://ftp.debian.org/debian jessie main
#deb-src http://ftp.debian.org/debian jessie main
eof

apt-get update


#0
#fix sid(2016.10.18) "egg chicken issue" (dracut linux-image), run on HOST
while true; do
    sed -i '/^dracut -q/s+^+#+' /srv/nfs/GNULinux-debian-sid-arm*/etc/kernel/postinst.d/dracut.dpkg-new
    sleep 1m
done

#1
#arm64
apt-get install linux-image-arm64 linux-headers-arm64 dkms \
    initramfs-tools- dracut dracut-network sysvinit-core systemd-sysv- \
    autoconf automake bash binutils bison bzip2 coreutils diffutils \
    file findutils flex gawk gcc grep gzip \
    libc6 libtool-bin m4 mawk- make patch sed tar texinfo xz-utils \
    bc libncurses5-dev \
    console-setup console-data locales kbd \
    network-manager wireless-tools wpasupplicant pppoe pppoeconf \
    aptitude info man vim less debootstrap gettext \
    openssh-client openssh-server openssh-blacklist* \
    parted btrfs-tools squashfs-tools dosfstools \
    dmsetup kpartx multipath-tools- lvm2 gdisk \
    libgtk*- libqt*- texlive-base- ruby*- -d

#armhf
apt-get install linux-image-armmp linux-headers-armmp dkms \
    initramfs-tools- dracut dracut-network sysvinit-core systemd-sysv- \
    autoconf automake bash binutils bison bzip2 coreutils diffutils \
    file findutils flex gawk gcc grep gzip \
    libc6 libtool-bin m4 mawk- make patch sed tar texinfo xz-utils \
    bc libncurses5-dev \
    console-setup console-data locales kbd \
    network-manager wireless-tools wpasupplicant pppoe pppoeconf \
    aptitude info man vim less debootstrap gettext \
    openssh-client openssh-server openssh-blacklist* \
    parted btrfs-tools squashfs-tools dosfstools \
    dmsetup kpartx multipath-tools- lvm2 gdisk \
    libgtk*- libqt*- texlive-base- ruby*- -d

#x86_64
apt-get install linux-image-amd64 linux-headers-amd64 dkms \
    initramfs-tools- dracut dracut-network sysvinit-core systemd-sysv- \
    autoconf automake bash binutils bison bzip2 coreutils diffutils \
    file findutils flex gawk gcc grep gzip \
    libc6 libtool-bin m4 mawk- make patch sed tar texinfo xz-utils \
    bc libncurses5-dev \
    console-setup console-data locales kbd \
    network-manager wireless-tools wpasupplicant pppoe pppoeconf \
    aptitude info man vim less debootstrap gettext \
    openssh-client openssh-server openssh-blacklist* \
    parted btrfs-tools squashfs-tools dosfstools \
    dmsetup kpartx multipath-tools- lvm2 gdisk \
    libgtk*- libqt*- texlive-base- ruby*- -d


#2
#sid
apt-get install initramfs-tools- dracut dracut-network \
    pciutils usbutils ntp cpulimit \
    openssl openssl-blacklist* openvpn openvpn-blacklist* \
    git git-svn subversion sshfs rsync bzr python3 \
    gnupg2 gnupg-agent libgfshare-bin ssss \
    build-essential autogen strace lsof colordiff colorgcc colormake \
    bash-completion python-optcomplete iotop lshw pm-utils \
    screen tmux fuse linux-perf- sysfsutils \
    lm-sensors cpufrequtils laptop-mode-tools linux-cpupower powertop \
    wipe zerofree curl kexec-tools- pax-utils uuid sudo fakeroot \
    nfs-common nfs-kernel-server unbound unbound-host telnet ftp tftp \
    multiarch-support debian-ports-archive-keyring checkinstall \
    avahi-daemon libnss-mdns \
    alsa-utils pv pipemeter- hexedit zip unzip lzip lzop aria2 \
    selinux-utils setools selinux-policy-default \
    evtest esekeyd triggerhappy \
    libgtk*- libqt*- -d

#jessie
apt-get install initramfs-tools- dracut dracut-network \
    pciutils usbutils ntp cpulimit \
    openssl openssl-blacklist* openvpn openvpn-blacklist* \
    git git-svn subversion sshfs rsync bzr python3 \
    gnupg2 gnupg-agent libgfshare-bin ssss \
    build-essential autogen strace lsof colordiff colorgcc colormake \
    bash-completion python-optcomplete iotop lshw pm-utils \
    screen tmux fuse sysfsutils \
    lm-sensors cpufrequtils laptop-mode-tools powertop \
    wipe zerofree curl kexec-tools- pax-utils uuid sudo fakeroot \
    nfs-common nfs-kernel-server unbound unbound-host telnet ftp tftp \
    multiarch-support debian-ports-archive-keyring checkinstall \
    avahi-daemon libnss-mdns \
    alsa-utils pv pipemeter- hexedit zip unzip lzip aria2 \
    evtest esekeyd triggerhappy \
    libgtk*- libqt*- -d



cat > /etc/network/interfaces << eof
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

# The loopback network interface
auto lo
iface lo inet loopback

#auto eth0
#iface eth0 inet dhcp

#auto wlan0
#iface wlan0 inet dhcp
# wpa-ap-scan 1
# wpa-scan-ssid 1
# wpa-ssid ""
# wpa-psk "\"
eof

sed -i "s+#prepend domain-name-servers 127.0.0.1;+prepend domain-name-servers 127.0.0.1,8.8.8.8;+" /etc/dhcp/dhclient.conf

sed -i '/"syntax on/s+"++' /etc/vim/vimrc

sed -i -e "/en_US/s+# ++" -e "/zh_CN/s+# ++" /etc/locale.gen
locale-gen

sed -i "s+#RAMTMP=no+RAMTMP=yes+" /etc/default/tmpfs
#sid
cp -a /usr/share/systemd/tmp.mount /etc/systemd/system/; systemctl enable tmp.mount
#jessie
#cp -a /lib/systemd/system/tmp.mount /etc/systemd/system/; systemctl enable tmp.mount

cp -a /lib/udev/rules.d/80-net-setup-link.rules /etc/udev/rules.d/

for k in $(ls /boot/vmlinuz-* | sed "s+/boot/vmlinuz-++"); do
    dracut --no-hostonly --add "dmsquash-live" \
        --omit "" --omit-drivers "" \
        --install "/bin/dd /bin/ps /bin/sync /etc/systemd/system/tmp.mount /etc/udev/rules.d/80-net-setup-link.rules" \
        --gzip -f /boot/initrd.img-$k $k
    chmod 644 /boot/initrd.img-$k
done

#rm /etc/ssh/ssh_host_*; dpkg-reconfigure openssh-server


#3
apt-get install xserver-xorg-core xinit twm- xterm xutils xcursor-themes \
    openbox xserver-xorg-input-all xserver-xorg-video-all \
    xserver-xorg-video-dummy \
    fonts-dejavu gucharmap \
    chromium chromium-l10n \
    bluez blueman rfkill \
    gnome-shell gnome-shell-extensions gnome-core gdm3- lightdm- \
    gnome-builder \
    xdg-utils xdg-user-dirs xdg-user-dirs-gtk \
    ibus ibus-pinyin ibus-libpinyin ibus-gtk* ibus-qt* ibus-clutter ibus-wayland \
    gconf-editor gnome-tweak-tool \
    weston \
    cmake clang \
    lxc bubblewrap bootchart- -d



groupadd -g 3001 aid_net_bt_admin
groupadd -g 3002 aid_net_bt
groupadd -g 3003 aid_inet
groupadd -g 3004 aid_net_raw
groupadd -g 3005 aid_net_admin

usermod -a -G aid_net_bt_admin,aid_net_bt,aid_inet,aid_net_raw,aid_net_admin root
usermod -a -G aid_net_bt_admin,aid_net_bt,aid_inet,aid_net_raw,aid_net_admin user

