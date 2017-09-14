DESCRIPTION = "console image for nanopi-neo"


SYSTEM_PKG_INSTALL = " \
	kernel-modules apmd \
	e2fsprogs e2fsprogs-e2fsck \
	e2fsprogs-mke2fs e2fsprogs-resize2fs \
	parted dosfstools \
	"

UTILS_PKG_INSTALL = " \
	usbutils nano \
	screen usb-modeswitch tzdata \
	"

NETWORK_PKG_INSTALL = " \
	net-tools \
	ppp ppp-dialin \
	wireless-tools wpa-supplicant \
	wget curl \
	"

IMAGE_INSTALL = " \
	packagegroup-core-boot \
	packagegroup-core-full-cmdline \
	packagegroup-core-buildessential \
	\
	${CORE_IMAGE_EXTRA_INSTALL} \
	\
	${SYSTEM_PKG_INSTALL} \
	${UTILS_PKG_INSTALL} \
	${NETWORK_PKG_INSTALL} \
	"

IMAGE_FEATURES += "ssh-server-openssh"

IMAGE_LINGUAS = " "

export IMAGE_BASENAME = "npi-console"

inherit core-image
