#!/usr/bin/env bash

PACKAGE_LIST=(
	vim
	tilix
	zsh
	fira-code-fonts
	lutris
	akmod-nvidia
	steam
	geary
	hydrapaper
)

FLATPAK_LIST=(
	discord
	spotify
	komikku
	glimpse
)

# enable rpmfusion
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y

sudo dnf groupupdate core -y

# install multimedia packages
sudo dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin -y

sudo dnf groupupdate sound-and-video -y

# fedora better fonts
sudo dnf copr enable dawid/better_fonts -y
sudo dnf install fontconfig-enhanced-defaults fontconfig-font-replacements -y

# iterate through packages and installs them if not already installed
for package_name in ${PACKAGE_LIST[@]}; do
	if ! sudo dnf list --installed | grep -q $package_name; then
		sudo dnf install "$package_name" -y
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
sudo dnf upgrade -y
sudo dnf autoremove -y
