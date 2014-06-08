#!/bin/bash

export PATH="${HOME}/x-tools/armv7-unknown-linux-gnueabi/bin/:${PATH}"

# from http://www.gentoo.org/proj/en/base/embedded/handbook/?part=1&chap=4
#
# ARCH            ?= arm
# CROSS_COMPILE   ?= arm-unknown-linux-gnu-

export ARCH=arm
export CROSS_COMPILE=armv7-unknown-linux-gnueabi-

makeopts="ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE}"

set -x
make ${makeopts} clean distclean mrproper
rc=${?}
set +x

if [[ ${rc} -ne 0 ]];
then
    echo "make clean distclean returned ${rc}!";
    exit ${rc};
fi;

set -x
make ${makeopts} exynos_defconfig
rc=${?}
set +x

if [[ ${rc} -ne 0 ]];
then
    echo "make exynos_defconfig returned ${rc}!";
    exit ${rc};
fi;

exit 0;

