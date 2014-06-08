#!/bin/bash

# On a Linux workstation

DEV=/dev/sdb
MNT=/mnt

set -x

# Mount / and /boot/, then copy over compiled kernel and modules

mount ${DEV}4 ${MNT}
mount ${DEV}3 ${MNT}/boot/

cp arch/arm/boot/uImage arch/arm/boot/dts/exynos5250-snow.dtb ${MNT}/boot/

rm -rf ${MNT}/lib/modules/*

rsync -avAX dist/ ${MNT}/

umount ${MNT}/boot/
umount ${MNT}

exit 0

