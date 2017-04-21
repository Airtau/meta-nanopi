SECTION = "kernel"
DESCRIPTION = "Mainline Linux kernel"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=d7810fab7487fb0aad327b76f1be7cd7"

inherit kernel

require recipes-kernel/linux/linux-dtb.inc
require recipes-kernel/linux/linux.inc

RDEPENDS_kernel-base += "kernel-devicetree"

KERNEL_EXTRA_ARGS += "LOADADDR=${UBOOT_ENTRYPOINT}"

KCONFIG_MODE = "--alldefconfig"

S = "${WORKDIR}/git"

PV = "4.10"
SRCREV_pn-${PN} = "645019bce81bb088d150a90b41d19cf1da1facac"

SRC_URI = " \
	git://github.com/megous/linux.git;branch=orange-pi-4.10 \
	file://defconfig \
	file://add-configfs-overlay-for-v4.10.x.patch \
	file://add-h3-aliases.patch \
	file://add-h3-overlays.patch \
	file://add-overlay-compilation-support.patch \
	file://add-uart-rts-cts-pins.patch \
	file://nanopi-dvfs-and-emac.patch \
	file://scripts-dtc-Update-to-version-with-overlays.patch \
	file://spidev-remove-warnings.patch \
	file://spi-sun6i-allow-large-transfers.patch \
	"
