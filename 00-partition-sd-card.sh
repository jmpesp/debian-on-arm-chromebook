#!/bin/bash

# On a Linux workstation

DEV=/dev/sdb
MNT=/mnt

set -x

# Zero out current partition table
dd if=/dev/zero of=${DEV} bs=512 count=1

# Partitioning the device:
parted --script ${DEV} mklabel gpt

cgpt create ${DEV}

cgpt boot -p ${DEV}

# from https://plus.google.com/+OlofJohansson/posts/bQpzEGG15G8
#
# Partition 1: Kernel partition, regular Chrome OS kernel for whatever need you might have (i.e. same as previous instructions)
# Partition 2: Another kernel partition with nv-u-boot on it at higher priority
# Partition 3: Ext2 filesystem for /boot (important, should be ext2)
# Partition 4: rootfs for Linux, ext4 or whatever you prefer
# plus:
# Partition 5: home partition, encrypted

# cgpt expects 512-byte blocks:
let "max=`blockdev --getsz ${DEV}`"

let "offs=512"
let "size=1280"
cgpt add -b ${offs} -s ${size} -t kernel -P 2 -S 1 -l CHROMEOS ${DEV}

let "offs = offs + size"
let "size=128000"
cgpt add -b ${offs} -s ${size} -t kernel -P 3 -S 0 -T 10 -l NVUBOOT ${DEV}

let "offs = offs + size"
let "size=1280000"
# size = 625 MiB
# >>> 1280000.0 * 512 / 1024 / 1024
# 625.0
cgpt add -b ${offs} -s ${size} -t rootfs -P 1 -S 1 -l BOOT ${DEV}

let "offs = offs + size"
let "size = (max - offs) / 4"
cgpt add -b ${offs} -s ${size} -t rootfs -P 1 -S 1 -l ROOT ${DEV}

let "offs = offs + size"
let "size = max - offs - 1024"
cgpt add -b ${offs} -s ${size} -t rootfs -P 1 -S 1 -l HOME ${DEV}

cgpt show ${DEV}

exit 0

