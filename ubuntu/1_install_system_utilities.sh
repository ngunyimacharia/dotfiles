# Install various utilities
sudo apt install curl -y
 
sudo apt install xclip -y

sudo apt-get install ripgrep -y

sudo apt install fzf -y

sudo apt install copyq -y

sudo apt install bat -y

sudo apt-get install curl network-manager libnss3-tools jq xsel -y

# Required to run AppImage
sudo apt install libfuse2 

# Instal JetBrainsMono font
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"

# Install Flatpak
sudo apt install flatpak

# Install 1Password

curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
 
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | sudo tee /etc/apt/sources.list.d/1password.list
 
sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg
 
sudo apt update && sudo apt install 1password -y

# Install KDE Connect
sudo apt install kdeconnect

# Install Gnome Tweak Tool and Extension Manager
sudo apt install gnome-tweaks
sudo apt install gnome-shell-extension-manager

sudo apt install lm-sensors # Required for Astra Monitor (https://extensions.gnome.org/extension/6682/astra-monitor/)

# Install WireGuard
sudo apt install wireguard

# Install Just
sudo apt install just
