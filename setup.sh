# disable debian networking and dhcpcd
sudo -Es
systemctl mask networking.service
systemctl mask dhcpcd.service
mv /etc/network/interfaces /etc/network/interfaces~
sed -i '1i resolvconf=NO' /etc/resolvconf.conf

# enable systemd-networkd
systemctl enable systemd-networkd.service
systemctl enable systemd-resolved.service
ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf
