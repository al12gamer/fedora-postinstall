#!/usr/bin/env bash

PACKAGE_LIST=(
	vim
	ProtonUpdater
	zsh
	fira-code-fonts
	lutris
	akmod-nvidia
	steam
	geary
	jotta-cli
)

FLATPAK_LIST=(
	com.spotify.Client
	info.febvre.Komikku
	org.glimpse_editor.Glimpse
	org.gnome.Podcasts
	org.gnome.gitlab.somas.Apostrophe
)

# enable rpmfusion
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -yq

sudo dnf groupupdate core -yq

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
sudo dnf copr enable david35mm/ProtonUpdater

# update repositories

sudo dnf check-update -yq

# iterate through packages and installs them if not already installed
for package_name in ${PACKAGE_LIST[@]}; do
	if ! sudo dnf list --installed | grep -q ^$package_name; then
		sudo dnf install "$package_name" -yq
	else
		echo "$package_name already installed"
	fi
done

for flatpak_name in ${FLATPAK_LIST[@]}; do
	if ! flatpak list | grep -q ^$flatpak_name; then
		flatpak install "$flatpak_name" -y
	else
		echo "$package_name already installed"
	fi
done

# upgrade packages
sudo dnf upgrade -yq
sudo dnf autoremove -yq
