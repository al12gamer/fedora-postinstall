#!/usr/bin/env bash

PACKAGE_LIST=(
	vim
	calibre
	fish
	fira-code-fonts
	lutris
	steam
	vlc
	vlc-plugin-access-extra
	mcomix3
	htop
	gnome-boxes
	gnome-tweaks
	python3
	python3-pip
	youtube-dl
	neofetch
	pv
	wget
	wine
	winetricks
	discord
	linux-util-user
	fwupd
	qbittorrent
	cpu-x
	heif-gdk-pixbuf
	kitty
)

FLATPAK_LIST=(
	org.telegram.desktop
	net.veloren.airshipper
	net.davidotek.pupgui2
	org.signal.Signal
)

# gnome settings
gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true

# enable rpmfusion
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y

sudo dnf groupupdate core -y

# install development tools 
sudo dnf groupinstall "Development Tools" -y

# install multimedia packages

sudo dnf groupinstall multimedia -y
sudo dnf groupupdate multimedia -y
sudo dnf groupupdate sound-and-video -y

# fedora better fonts
sudo dnf copr enable dawid/better_fonts -y
sudo dnf install fontconfig-enhanced-defaults fontconfig-font-replacements -y

# add flathub repository
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# add third party software

# add brave browser for chromium testing pages
sudo dnf install dnf-plugins-core -y
sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
sudo dnf install brave-browser
 
# update repositories

sudo dnf check-update -y

# iterate through packages and installs them if not already installed
for package_name in ${PACKAGE_LIST[@]}; do
	if ! sudo dnf list --installed | grep -q "^\<$package_name\>"; then
		echo "installing $package_name..."
		sleep .5
		sudo dnf install "$package_name" -y
		echo "$package_name installed"
	else
		echo "$package_name already installed"
	fi
done

for flatpak_name in ${FLATPAK_LIST[@]}; do
	if ! flatpak list | grep -q $flatpak_name; then
		flatpak install "$flatpak_name" -y
	else
		echo "$package_name already installed"
	fi
done



# add Mullvad
wget --content-disposition https://mullvad.net/download/app/rpm/latest

## add liquorix kernel for better performance, basically zen kernel
sudo dnf copr enable rmnscnce/kernel-lqx

# upgrade packages
sudo dnf distro-sync -y && sudo dnf update --refresh -y && flatpak update -y && flatpak remove --unused && sudo fwupdmgr get-updates
sudo dnf autoremove -y
sudo dnf install kernel-lqx -y

echo "-----------heres your fish alias-----------"
sleep 2
echo " ul='sudo dnf distro-sync -y && sudo dnf update --refresh -y && flatpak update -y && flatpak remove --unused && sudo fwupdmgr get-updates && sudo dnf autoremove -y' "


echo "************************************************"
echo "All good to go! Feel free to reboot your machine!"
echo "************************************************"
sleep 10
