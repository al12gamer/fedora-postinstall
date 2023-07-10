#!/usr/bin/env bash
# this script assumes a Fedora Gnome install
# TODO - take packages from flatpak and dnf package lists, and add to ansible role...also have this bash script mainly install ansible and run the role

PACKAGE_LIST=(
	vim
	btop
	calibre
 	cowsay
  	asciinema
	fira-code-fonts
	lutris
	steam
	vlc
	vlc-plugin-access-extra
	mcomix3
	htop
	gnome-boxes
	python3
	python3-pip
	youtube-dl
	neofetch
	pv
	wget
	wine
	winetricks
	discord
	fwupd
	qbittorrent
	cpu-x
	heif-gdk-pixbuf
)

FLATPAK_LIST=(
	org.telegram.desktop
	net.veloren.airshipper
	net.davidotek.pupgui2
	org.signal.Signal
	info.febvre.Komikku
 	im.riot.Riot
  	org.onionshare.OnionShare
)

# enable rpmfusion
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y

sudo dnf groupupdate core -y

# install development tools 
sudo dnf groupinstall "Development Tools" -y

# install multimedia packages

sudo dnf groupinstall multimedia -y
sudo dnf groupupdate multimedia -y
sudo dnf groupupdate sound-and-video -y

# add flathub repository
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# add third party software

# add brave browser for chromium testing pages
sudo dnf install dnf-plugins-core -y
sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
sudo dnf install brave-browser -y
 
# update repositories

sudo dnf check-update -y

# iterate through packages and installs them if not already installed
for package_name in ${PACKAGE_LIST[@]}; do
	if ! sudo dnf list --installed | grep -q "^\<$package_name\>"; then
		echo "installing $package_name..."
		sleep .5
		sudo dnf install "$package_name" -yq
		echo "$package_name installed"
	else
		echo "$package_name already installed"
	fi
done

for flatpak_name in ${FLATPAK_LIST[@]}; do
	if ! flatpak list | grep -q $flatpak_name; then
		flatpak install "$flatpak_name" -yq
	else
		echo "$package_name already installed"
	fi
done



# add Mullvad
cd /home/$USER/Downloads && wget --content-disposition https://mullvad.net/download/app/rpm/latest
cd

echo "ADDING BASH ALIASES"
sleep 2
alias -p ul='sudo dnf distro-sync -y && sudo dnf update --refresh -y && flatpak update -y && flatpak remove --unused && sudo fwupdmgr get-updates && sudo dnf autoremove -y'
sleep 2
alias -p mup='cd /home/$USER/Downloads && sudo rm -r Mullvad*.rpm && sudo dnf remove mullvad-vpn -y && wget --content-disposition https://mullvad.net/download/app/rpm/latest && sudo rpm -i Mullvad*.rpm && cd && cowsay DONE NOW'
clear
alias
sleep 4

echo "************************************************"
echo "All good to go! Feel free to reboot your machine!"
echo "************************************************"
sleep 10
