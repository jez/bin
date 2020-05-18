#!/bin/bash

# TODO(jez) This doesn't work.

set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 <vps_public_ip>"
fi

vps_public_ip=$1

sudo add-apt-repository -y ppa:wireguard/wireguard
sudo apt install -y wireguard qrencode

umask 077

wg genkey | tee jez-pihole-01.private | wg pubkey > jez-pihole-01.public

sudo tee /etc/wireguard/wg0.conf > /dev/null <<EOF
[Interface]
Address = 10.200.200.1/24
ListenPort = 51820
PrivateKey = $(< ./jez-pihole-01.private)
PostUp   = iptables -A FORWARD -i %i -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
EOF

sudo ufw allow 51820/udp
sudo ufw enable

wg-quick up wg0
sudo systemctl enable wg-quick@wg0

# ----- jez-laptop-01 ---------------------------------------------------------

wg genkey | tee jez-laptop-01.private | wg pubkey > jez-laptop-01.public

cat > jez-laptop-01.conf <<EOF
[Interface]
Address = 10.200.200.2/32
PrivateKey = $(< ./jez-laptop-01.private)

[Peer]
PublicKey = $(< ./jez-pihole-01.public)
Endpoint = $vps_public_ip:51820
AllowedIPs = 0.0.0.0/0, ::/0
EOF

sudo tee -a /etc/wireguard/wg0.conf > /dev/null <<EOF

[Peer]
PublicKey = $(< ./jez-laptop-01.public)
AllowedIPs = 10.200.200.2/32
EOF

# ----- jez-iphone7-01 --------------------------------------------------------

qrencode -t ansiutf8 < jez-laptop-01.conf

# IP address: 10.200.200.1/24
# Gateway:    10.200.200.1
#
# wg0
# 167.x.x.x
#
# https://www.linode.com/docs/networking/vpn/set-up-wireguard-vpn-on-ubuntu/
# https://snikt.net/blog/2020/01/29/building-a-simple-vpn-with-wireguard-with-a-raspberry-pi-as-server/
# https://drexl.me/guides/wireguard-pihole-vpn-setup.html
