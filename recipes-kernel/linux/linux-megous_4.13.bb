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

PV = "4.13"
SRCREV_pn-${PN} = "c173fe35989ed23e9f14379550a056969ef6140c"

SRC_URI = " \
	git://github.com/megous/linux.git;branch=orange-pi-4.13 \
	file://defconfig \
	file://add-configfs-overlay-for-v4.13.x.patch \
	file://add-h3-overlays.patch \
	file://add-overlay-compilation-support.patch \
	"
