#!/bin/bash


# check if running as root
if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root"
	exit 1
fi

systemctl start wpa_supplicant@ap0
exit 0