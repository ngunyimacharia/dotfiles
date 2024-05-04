# Install Kitty
sudo dnf install kitty

# Setup LazyVim 
sudo dnf install neovim

sudo dnf copr enable maveonair/jetbrains-mono-nerd-fonts
sudo dnf install jetbrains-mono-nerd-fonts jetbrains-mono-nerd-fonts

sudo dnf copr enable atim/lazygit -y
sudo dnf install lazygit -y

sudo dnf install ripgrep

# Install Pyenv
curl https://pyenv.run | bash

# Install Docker
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl start docker
sudo systemctl enable docker
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

# Install Chrome
sudo dnf install fedora-workstation-repositories
sudo dnf config-manager --set-enabled google-chrome
sudo dnf install google-chrome-stable -y

# Install PHP
sudo dnf install http://rpms.remirepo.net/fedora/remi-release-40.rpm -y
sudo dnf module list php
sudo dnf module enable php:remi-8.2 -y
sudo dnf install php-{fpm,cli,posix,process,mbstring,mcrypt,xml,soap,sodium} -y

# Install composer
./scripts/composer-install.sh

composer global install

# Install Devbox
curl -fsSL https://get.jetify.com/devbox | bash
