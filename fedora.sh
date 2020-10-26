#!/usr/bin/env bash

VSCODE_URL="https://go.microsoft.com/fwlink/\?LinkID\=760867"

DOWNLOAD_DIRECTORY="$HOME/Downloads"

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
	com.spotify.Client
	info.febvre.Komikku
	org.glimpse_editor.Glimpse
	org.gnome.Podcasts
	org.gnome.gitlab.somas.Apostrophe
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

# add flathub repository
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# download third party software

wget $VSCODE_URL -O $DOWNLOAD_DIRECTORY/code.rpm

# install third party software

sudo dnf install $DOWNLOAD_DIRECTORY/*.rpm

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
