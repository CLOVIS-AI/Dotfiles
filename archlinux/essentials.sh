#!/usr/bin/env sh

# This script is intended to be run after you have installed a basic ArchLinux to ensure you have everything necessary
# for day-to-day use.

pacman -Syuu --needed linux linux-firmware intel-ucode lsb-release \
	iwd nmap openssh sshfs openssl openvpn rsync traceroute dnsutils ntp \
	nano zsh sudo git which \
	man-db man-pages texinfo file \
	curl wget \
	efibootmgr cfdisk reflector cronie \
	gnupg pinentry \
	hdparm \
	neofetch htop lsof \
	dmidecode \
	zip unzip p7zip lzop
