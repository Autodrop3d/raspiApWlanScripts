#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# disable debian networking and dhcpcd
systemctl mask networking.service
systemctl mask dhcpcd.service
mv /etc/network/interfaces /etc/network/interfaces~
sed -i '1i resolvconf=NO' /etc/resolvconf.conf

# enable systemd-networkd
systemctl enable systemd-networkd.service
systemctl enable systemd-resolved.service
ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf

cat >/etc/wpa_supplicant/wpa_supplicant-wlan0.conf <<EOF
country=DE
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

network={
    ssid="TestNet"
    psk="verySecretPwassword"
}
EOF

chmod 600 /etc/wpa_supplicant/wpa_supplicant-wlan0.conf
systemctl disable wpa_supplicant.service
systemctl enable wpa_supplicant@wlan0.service

cat > /etc/wpa_supplicant/wpa_supplicant-ap0.conf <<EOF
country=DE
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

network={
    ssid="RPiNet"
    mode=2
    key_mgmt=WPA-PSK
    proto=RSN WPA
    psk="anotherPassword"
    frequency=2412
}
EOF

chmod 600 /etc/wpa_supplicant/wpa_supplicant-ap0.conf

cat > /etc/systemd/network/08-wlan0.network <<EOF
[Match]
Name=wlan0
[Network]
DHCP=yes
EOF

cat > /etc/systemd/network/12-ap0.network <<EOF
[Match]
Name=ap0
[Network]
Address=192.168.4.1/24
DHCPServer=yes
[DHCPServer]
DNS=84.200.69.80 84.200.70.40
EOF

systemctl disable wpa_supplicant@ap0.service
cp /lib/systemd/system/wpa_supplicant@.service /etc/systemd/system/wpa_supplicant@ap0.service
sed -i 's/Requires=sys-subsystem-net-devices-%i.device/Requires=sys-subsystem-net-devices-wlan0.device/' /etc/systemd/system/wpa_supplicant@ap0.service
sed -i 's/After=sys-subsystem-net-devices-%i.device/After=sys-subsystem-net-devices-wlan0.device/' /etc/systemd/system/wpa_supplicant@ap0.service
sed -i '/After=sys-subsystem-net-devices-wlan0.device/a Conflicts=wpa_supplicant@wlan0.service/' /etc/systemd/system/wpa_supplicant@ap0.service
sed -i '/Type=simple/a EecStarxtPre=/sbin/iw dev wlan0 interface add ap0 type __ap/' /etc/systemd/system/wpa_supplicant@ap0.service
sed -i '/ExecStart/a ExecStopPost=/sbin/iw dev ap0 del/' /etc/systemd/system/wpa_supplicant@ap0.service
systemctl daemon-reload

systemctl enable wpa_supplicant@wlan0.service
systemctl disable wpa_supplicant@ap0.service

reboot now