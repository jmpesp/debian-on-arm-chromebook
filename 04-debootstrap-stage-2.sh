#!/bin/bash

# On the Chromebook

DEV=/dev/mmcblk1
MNT=/mnt

# Chroot into the SD card, and perform the second debootstrap stage

umount ${DEV}p[1-5]

mount ${DEV}p4 ${MNT}
[[ ${?} -eq 0 ]] || exit 1;

# Bind the following special filesystems for use in the chroot
mount --bind /dev/ ${MNT}/dev/
[[ ${?} -eq 0 ]] || exit 1;
mount --bind /proc/ ${MNT}/proc/
[[ ${?} -eq 0 ]] || exit 1;
mount --bind /sys/ ${MNT}/sys/
[[ ${?} -eq 0 ]] || exit 1;

chroot ${MNT} /debootstrap/debootstrap --second-stage
[[ ${?} -eq 0 ]] || exit 1;

# Setup /etc/fstab for the two unencrypted partitions

cat > ${MNT}/etc/fstab <<EOF
${DEV}p4 / ext4 errors=remount-ro 0 1
${DEV}p3 /boot/ ext2 errors=remount-ro 0 1
EOF

# Populate the /etc/apt/sources.list with target = wheezy

cat > ${MNT}/etc/apt/sources.list <<EOF
deb http://ftp.ca.debian.org/debian wheezy main non-free contrib
deb-src http://ftp.ca.debian.org/debian wheezy main non-free contrib
EOF

# Update the packages

chroot ${MNT} apt-get update
[[ ${?} -eq 0 ]] || exit 1;

chroot ${MNT} apt-get upgrade
[[ ${?} -eq 0 ]] || exit 1;

# Install useful packages
chroot ${MNT} apt-get install wpasupplicant iw upower cryptsetup

echo "yourhostname" > ${MNT}/etc/hostname

# Set the root password
chroot ${MNT} passwd

# Copy over built-in wireless firmware
mkdir ${MNT}/lib/firmware/mrvl/
cp /lib/firmware/mrvl/* ${MNT}/lib/firmware/mrvl/

umount ${MNT}/dev/
umount ${MNT}/proc/
umount ${MNT}/sys/
umount ${MNT}

exit 0

