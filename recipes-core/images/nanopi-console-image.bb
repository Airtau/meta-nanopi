require recipes-core/images/core-image-minimal.bb

DESCRIPTION = "console image for nanopi-neo"

IMAGE_FEATURES += "ssh-server-openssh"

KERNEL_PKG_INSTALL = " \
	kernel-modules \
	"

SYSTEM_PKG_INSTALL = " \
	apmd \
	e2fsprogs e2fsprogs-e2fsck e2fsprogs-mke2fs e2fsprogs-resize2fs \
	parted dosfstools \
	"

LIB_PKG_INSTALL = " \
	glib-2.0 \
	"

UTILS_PKG_INSTALL = " \
	coreutils \
	usbutils \
	bash findutils grep \
	sed tar zlib \
	screen usb-modeswitch tzdata \
	"

# packagegroup-core-buildessential
DEV_PKG_INSTALL = " \
	nano \
	autoconf \
	automake \
	binutils \
	binutils-symlinks \
	cpp \
	cpp-symlinks \
	gcc \
	gcc-symlinks \
	g++ \
	g++-symlinks \
	gettext \
	make \
	libstdc++ \
	libstdc++-dev \
	libtool \
	pkgconfig \
	"

NETWORK_PKG_INSTALL = " \
	net-tools dhcpcd \
	ppp ppp-dialin \
	wireless-tools wpa-supplicant \
	wget curl \
	iproute2 iputils \
	"

IMAGE_INSTALL += " \
	${KERNEL_PKG_INSTALL} \
	${SYSTEM_PKG_INSTALL} \
	${LIB_PKG_INSTALL} \
	${UTILS_PKG_INSTALL} \
	${DEV_PKG_INSTALL} \
	${NETWORK_PKG_INSTALL} \
	"
