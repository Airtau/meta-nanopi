require nanopi-console-image.bb

DESCRIPTION = "GUI image for nanopi boards"

export IMAGE_BASENAME = "npi-gui"

IMAGE_FEATURES += "splash x11-base"

inherit distro_features_check

REQUIRED_DISTRO_FEATURES = "x11"
