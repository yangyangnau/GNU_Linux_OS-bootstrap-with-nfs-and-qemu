#!/bin/sh

#https://wiki.debian.org/Arm64Qemu
#https://wiki.ubuntu.com/ARM64/QEMU
#https://wiki.linaro.org/Platform/DevPlatform/AArch64QEMU

#https://wiki.linaro.org/PeterMaydell/QemuVersatileExpress
#https://wiki.linaro.org/PeterMaydell/KVM/HowTo/KVMGuestSetup

apt-get install qemu qemu-user-static binfmt-support


O="GNULinux" D="debian" R="sid" A="arm64" P="/srv/nfs/$O-$D-$R-$A" Q="aarch64"
#O="GNULinux" D="debian" R="jessie" A="arm64" P="/srv/nfs/$O-$D-$R-$A" Q="aarch64"
#O="GNULinux" D="debian" R="sid" A="armhf" P="/srv/nfs/$O-$D-$R-$A" Q="arm"
#O="GNULinux" D="debian" R="jessie" A="armhf" P="/srv/nfs/$O-$D-$R-$A" Q="arm"
#O="GNULinux" D="debian" R="sid" A="x86_64" P="/srv/nfs/$O-$D-$R-$A" Q="x86_64"
#O="GNULinux" D="debian" R="jessie" A="x86_64" P="/srv/nfs/$O-$D-$R-$A" Q="x86_64"

qemu-system-$Q -name "$O-$D-$R-$A" \
  -M virt -cpu cortex-a57 -smp 2 -m 1024 \
  -serial stdio \
  -netdev user,id=net0,hostfwd=tcp::2222-:22 \
  -device virtio-net-device,netdev=net0 \
  -kernel $P/vmlinuz \
  -initrd $P/initrd.img \
  -append "ip=eth0:dhcp root=nfs:10.0.2.2:/$P:vers=3,nolock ro console=ttyAMA0 rd.luks=0 rd.md=0 rd.dm=0 rd.lvm=0"

exit 0

qemu-system-$Q -name "$O-$D-$R-$A" \
  -M virt -cpu cortex-a57 -smp 2 -m 1024 \
  -serial stdio \
  -netdev user,id=net0,hostfwd=tcp::2222-:22 \
  -device virtio-net-device,netdev=net0 \
  -kernel $P/vmlinuz \
  -initrd $P/initrd.img \
  -drive file="$O-$D-$R-$A.img",if=none,id=disk0 \
  -device virtio-blk-device,drive=disk0 \
  -append "root=/dev/vda ro console=ttyAMA0 rd.luks=0 rd.md=0 rd.dm=0 rd.lvm=0"
