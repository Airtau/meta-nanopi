DESCRIPTION="Mainline u-boot for nanopi devices"

require recipes-bsp/u-boot/u-boot.inc

DEPENDS += "dtc-native"

LICENSE = "GPLv2"

LIC_FILES_CHKSUM = "\
    file://Licenses/Exceptions;md5=338a7cb1e52d0d1951f83e15319a3fe7 \
    file://Licenses/bsd-2-clause.txt;md5=6a31f076f5773aabd8ff86191ad6fdd5 \
    file://Licenses/bsd-3-clause.txt;md5=4a1190eac56a9db675d58ebe86eaf50c \
    file://Licenses/eCos-2.0.txt;md5=b338cb12196b5175acd3aa63b0a0805c \
    file://Licenses/gpl-2.0.txt;md5=b234ee4d69f5fce4486a80fdaf4a4263 \
    file://Licenses/ibm-pibs.txt;md5=c49502a55e35e0a8a1dc271d944d6dba \
    file://Licenses/isc.txt;md5=ec65f921308235311f34b79d844587eb \
    file://Licenses/lgpl-2.0.txt;md5=5f30f0716dfdd0d91eb439ebec522ec2 \
    file://Licenses/lgpl-2.1.txt;md5=4fbd65380cdd255951079008b364516c \
    file://Licenses/x11.txt;md5=b46f176c847b8742db02126fb8af92e2 \
    "

SRC_URI = " \
    git://git.denx.de/u-boot.git;branch=master \
    file://enable-dt-overlays-support.patch \
    file://boot-nanopi.cmd \
    "

SRCREV = "8537ddd769f460d7fb7a62a3dcc9669049702e51"

PV = "v2017.03+git${SRCPV}"

PE = "2"

S = "${WORKDIR}/git"

UBOOT_ENV_SUFFIX = "scr"
UBOOT_ENV = "boot"

SPL_BINARY="u-boot-sunxi-with-spl.bin"

do_compile_append() {
    ${B}/tools/mkimage -C none -A arm -T script -d ${WORKDIR}/boot-nanopi.cmd ${WORKDIR}/${UBOOT_ENV_BINARY}
}

do_deploy_append() {
    echo "rootfstype=ext4" > ${DEPLOYDIR}/boot-config.txt
    echo "extraargs=loglevel=3" >> ${DEPLOYDIR}/boot-config.txt
    echo "overlay_prefix=sun8i-h3" >> ${DEPLOYDIR}/boot-config.txt
    echo "overlays=spi-spidev i2c0 uart1 uart2 usbhost0 usbhost2 usbhost3" >> ${DEPLOYDIR}/boot-config.txt
    echo "param_spidev_spi_bus=0" >> ${DEPLOYDIR}/boot-config.txt
}
