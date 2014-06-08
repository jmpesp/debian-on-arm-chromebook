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
make ${makeopts} uImage dtbs -j5
rc=${?}
set +x

if [[ ${rc} -ne 0 ]];
then
    echo "make returned ${rc}!";
    exit ${rc};
fi;

# make modules

make -j5

mkdir dist/
make modules_install INSTALL_MOD_PATH=${PWD}/dist/

exit 0;

