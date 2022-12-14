#!/bin/sh

nice /opt/led.sh&
renice -n 19 `pidof led.sh`
dd if=/opt/emmc.img of=/dev/mmcblk1 bs=1K
dd if=/opt/backup/MLO of=/dev/mmcblk1 count=1 seek=1 bs=128k
dd if=/opt/backup/u-boot.img of=/dev/mmcblk1 count=2 seek=1 bs=384k
sync 
echo -e "o\n n\n p\n 1\n 8192\n +512M\n a\n 1\n w" | fdisk /dev/mmcblk1
sync ; sleep 1
partprobe /dev/mmcblk1
sync
mkfs.ext4 -F -L rootfs -O ^metadata_csum,^64bit /dev/mmcblk1p1
sync
mount /dev/mmcblk1p1 /mnt 
sync
rsync -a --numeric-ids  --exclude='/proc' --exclude='/sys' --exclude='/mnt'  / /mnt/
mkdir -p /mnt/proc /mnt/sys /mnt/mnt /mnt/boot/dtbs
mv /mnt/boot/*.dtb /mnt/boot/dtbs/
cp -f /opt/backup/uEnv.txt /mnt/boot/
sync
poweroff







