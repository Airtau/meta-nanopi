
SYSTEMD_SERVICE_${PN} = "wpa_supplicant.service"
#SYSTEMD_AUTO_ENABLE = "enable"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://wpa_supplicant-wlan0.conf \
    "

do_install_append () {
    if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then
        # remove "nl80211" and "wired" services
        rm ${D}${systemd_unitdir}/system/wpa_supplicant-*.service
        rm ${D}${sysconfdir}/wpa_supplicant.conf

        # enable "wlan0" service
        install -d ${D}${sysconfdir}/systemd/system/multi-user.target.wants
        ln -sf ${systemd_unitdir}/wpa_supplicant@.service \
               ${D}${sysconfdir}/systemd/system/multi-user.target.wants/wpa_supplicant@wlan0.service

        install -d ${D}${sysconfdir}/wpa_supplicant
        install -m 0644 ${WORKDIR}/wpa_supplicant-wlan0.conf ${D}${sysconfdir}/wpa_supplicant/
    fi
}

