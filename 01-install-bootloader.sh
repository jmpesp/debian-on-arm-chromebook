#!/bin/bash

# On a Linux workstation

DEV=/dev/sdb

set -x

dd if=nv_uboot-snow-simplefb.kpart of=${DEV}2

exit 0
