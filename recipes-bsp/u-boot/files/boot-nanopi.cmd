setenv load_addr "0x44000000"
setenv overlay_error "false"

if test -e mmc 0:1 config.txt; then
	#echo "Found kernel configuration file"
	load mmc 0:1 ${load_addr} config.txt
	env import -t ${load_addr} ${filesize}
fi

setenv bootargs console=${console} console=tty1 root=/dev/mmcblk0p2 rootfstype=${rootfstype} rootwait panic=10 ${extraargs}

# load kernel
load mmc 0:1 ${kernel_addr_r} uImage

# load device tree
load mmc 0:1 ${fdt_addr_r} ${fdtfile}
fdt addr ${fdt_addr_r}

# load overlays
fdt resize
for overlay in ${overlays}; do
	if load mmc 0:1 ${load_addr} overlays/${overlay_prefix}-${overlay}.dtbo; then
		#echo "Applying ${overlay_prefix}-${overlay}.dtbo overlay"
		fdt apply ${load_addr} || setenv overlay_error "true"
	fi
done

if test "${overlay_error}" = "true"; then
	echo "Error applying DT overlays, restoring original DT"
	load mmc 0:1 ${fdt_addr_r} ${fdtfile}
elif load mmc 0:1 ${load_addr} overlays/${overlay_prefix}-fixup.scr; then
	#echo "Applying ${overlay_prefix}-fixup.scr script"
	source ${load_addr}
fi

bootm ${kernel_addr_r} - ${fdt_addr_r}
