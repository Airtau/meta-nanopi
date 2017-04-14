inherit image_types


# This image depends on the rootfs image
IMAGE_TYPEDEP_nanopi-sdimg = "${SDIMG_ROOTFS_TYPE}"

# Boot partition volume id
BOOTDD_VOLUME_ID ?= "${MACHINE}"

# Boot partition size [in KiB] (will be rounded up to IMAGE_ROOTFS_ALIGNMENT)
BOOT_SPACE ?= "32768"

# Set alignment to 2MB [in KiB]
IMAGE_ROOTFS_ALIGNMENT = "2048"

# Use an uncompressed ext4 by default as rootfs
SDIMG_ROOTFS_TYPE ?= "ext4"
SDIMG_ROOTFS = "${IMGDEPLOYDIR}/${IMAGE_NAME}.rootfs.${SDIMG_ROOTFS_TYPE}"

IMAGE_DEPENDS_nanopi-sdimg += " \
	parted-native \
	mtools-native \
	dosfstools-native \
	virtual/kernel \
	u-boot \
	"

# SD card image name
SDIMG = "${IMGDEPLOYDIR}/${IMAGE_NAME}.sd.img"

IMAGE_CMD_nanopi-sdimg () {
	# Align partitions
	BOOT_SPACE_ALIGNED=$(expr ${BOOT_SPACE} + ${IMAGE_ROOTFS_ALIGNMENT} - 1)
	BOOT_SPACE_ALIGNED=$(expr ${BOOT_SPACE_ALIGNED} - ${BOOT_SPACE_ALIGNED} % ${IMAGE_ROOTFS_ALIGNMENT})
	SDIMG_SIZE=$(expr ${IMAGE_ROOTFS_ALIGNMENT} + ${BOOT_SPACE_ALIGNED} + $ROOTFS_SIZE)

	echo "Creating filesystem with Boot partition ${BOOT_SPACE_ALIGNED} KiB and RootFS $ROOTFS_SIZE KiB"

	# Initialize sdcard image file
	dd if=/dev/zero of=${SDIMG} bs=1024 count=0 seek=${SDIMG_SIZE}

	# Create partition table
	parted -s ${SDIMG} mklabel msdos
	# Create boot partition and mark it as bootable
	parted -s ${SDIMG} unit KiB mkpart primary fat32 ${IMAGE_ROOTFS_ALIGNMENT} $(expr ${BOOT_SPACE_ALIGNED} \+ ${IMAGE_ROOTFS_ALIGNMENT})
	parted -s ${SDIMG} set 1 boot on
	# Create rootfs partition to the end of disk
	parted -s ${SDIMG} -- unit KiB mkpart primary ext2 $(expr ${BOOT_SPACE_ALIGNED} \+ ${IMAGE_ROOTFS_ALIGNMENT}) -1s
	parted ${SDIMG} print

	# Create a vfat image with boot files
	BOOT_BLOCKS=$(LC_ALL=C parted -s ${SDIMG} unit b print | awk '/ 1 / { print substr($4, 1, length($4 -1)) / 512 /2 }')
	rm -f ${WORKDIR}/boot.img
	mkfs.vfat -n "${BOOTDD_VOLUME_ID}" -S 512 -C ${WORKDIR}/boot.img $BOOT_BLOCKS

	# Copy kernel image
	mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/${KERNEL_IMAGETYPE} ::

	# Copy u-boot script
	mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/boot.scr ::

	# Copy device tree files
	mmd -i ${WORKDIR}/boot.img overlays
	if test -n "${KERNEL_DEVICETREE}"; then
		for DTS_NAME in ${KERNEL_DEVICETREE}; do
			DTS_BASE_NAME=`basename ${DTS_NAME} | awk -F "." '{print $1}'`
			DTS_FILE="${DEPLOY_DIR_IMAGE}/${KERNEL_IMAGETYPE}-${DTS_BASE_NAME}"
			if [ -e "${DTS_FILE}.dtb" ]; then
				mcopy -i ${WORKDIR}/boot.img -s ${DTS_FILE}.dtb ::${DTS_BASE_NAME}.dtb
			else
				mcopy -i ${WORKDIR}/boot.img -s ${DTS_FILE}.dtbo ::overlays/${DTS_BASE_NAME}.dtbo
			fi
		done
	fi

	# Burn partitions
	dd if=${WORKDIR}/boot.img of=${SDIMG} conv=notrunc seek=1 bs=$(expr ${IMAGE_ROOTFS_ALIGNMENT} \* 1024) && sync

	# Copy rootfs
	dd if=${SDIMG_ROOTFS} of=${SDIMG} conv=notrunc seek=1 bs=$(expr 1024 \* ${BOOT_SPACE_ALIGNED} + ${IMAGE_ROOTFS_ALIGNMENT} \* 1024) && sync

	# Write u-boot and spl
	dd if=${DEPLOY_DIR_IMAGE}/u-boot-sunxi-with-spl.bin of=${SDIMG} bs=1024 seek=8 conv=notrunc && sync
}

