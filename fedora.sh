#!/usr/bin/env bash

PACKAGE_LIST=(
	vim
	calibre
	zsh
	fira-code-fonts
	lutris
	akmod-nvidia
	lutris
	steam
	legendary
	jotta-cli
	vlc
	gamemode
	ProtonUpdater
	mcomix3
	qbittorrent
	htop
	gnome-boxes
	handbrake
	gnome-extensions-app
	gnome-tweaks
	gnome-shell-extension-pop-shell
	python3
	youtube-dl
	neofetch
	nmap
	
)

FLATPAK_LIST=(
	info.febvre.Komikku
	org.gnome.Podcasts
	com.discordapp.Discord
	com.github.calo001.fondo
	io.lbry.lbry-app
	org.telegram.desktop
)

# gnome settings
gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-automatic true

# enable rpmfusion
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -yq

sudo dnf groupupdate core -yq

# install development tools 
sudo dnf groupinstall "Development Tools" -yq

# install multimedia packages
sudo dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin -yq

sudo dnf groupupdate sound-and-video -yq

# fedora better fonts
sudo dnf copr enable dawid/better_fonts -yq
sudo dnf install fontconfig-enhanced-defaults fontconfig-font-replacements -yq

# add flathub repository
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# add third party software

# add Proton Updater from COPR
sudo dnf copr enable david35mm/ProtonUpdater -yq

# add winepak flathub
sudo flatpak remote-add --if-not-exists winepak https://dl.winepak.org/repo/winepak.flatpakrepo

# add jotta-cli for backups
echo Jottacloud.txt > /etc/yum.repos.d/JottaCLI.repo

# update repositories

sudo dnf check-update -yq

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
		flatpak install "$flatpak_name" -y
	else
		echo "$package_name already installed"
	fi
done

# upgrade packages
sudo dnf upgrade -yq
sudo dnf autoremove -yq
