setenv bootargs console=${console} console=tty1 root=/dev/mmcblk0p2 rootwait panic=10 ${extra}
setenv load_addr "0x44000000"

if test -e mmc 0:1 config.txt; then
	#echo "Found kernel configuration file"
	load mmc 0:1 ${load_addr} config.txt
	env import -t ${load_addr} ${filesize}
fi

load mmc 0:1 ${fdt_addr_r} ${fdtfile}
load mmc 0:1 ${kernel_addr_r} uImage
bootm ${kernel_addr_r} - ${fdt_addr_r}
