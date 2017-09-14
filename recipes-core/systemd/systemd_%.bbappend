
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

PACKAGECONFIG += "networkd resolved"

SRC_URI += " \
    file://eth.network \
    file://wlan.network \
    "

FILES_${PN} += "{sysconfdir}/systemd/network/*"

do_install_append () {
    install -d ${D}${sysconfdir}/systemd/network/
    install -m 0644 ${WORKDIR}/*.network ${D}${sysconfdir}/systemd/network/
    ln -sf ../run/systemd/resolve/resolv.conf ${D}${sysconfdir}/resolv.conf
}
