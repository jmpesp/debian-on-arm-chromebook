#!/bin/bash

# On a Linux workstation

DEV=/dev/sdb

set -x

blockdev --rereadpt ${DEV}

# BOOT: /boot
mkfs.ext2 ${DEV}3

# ROOT: /, where debian root goes
mkfs.ext4 ${DEV}4

# HOME: luks encrypt
cryptsetup luksFormat ${DEV}5

exit 0

