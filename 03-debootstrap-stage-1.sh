#!/bin/bash

# On a Linux workstation

DEV=/dev/sdb
MNT=/mnt

set -x

# mount ROOT (/), and debootstrap into it
mount ${DEV}4 ${MNT}

debootstrap --arch=armhf --foreign wheezy ${MNT} ftp://ftp.ca.debian.org/debian

umount ${MNT}

exit 0

