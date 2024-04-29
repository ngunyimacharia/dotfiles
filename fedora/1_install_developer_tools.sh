# Install Kitty
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

# Setup LazyVim 
sudo dnf install neovim

sudo dnf copr enable maveonair/jetbrains-mono-nerd-fonts
sudo dnf install jetbrains-mono-nerd-fonts jetbrains-mono-nerd-fonts

sudo dnf copy enable atim/lazygit -y
sudo dnf install lazygit

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

# Install Docker Desktop
wget https://desktop.docker.com/linux/main/amd64/docker-desktop-4.22.1-x86_64.rpm
sudo dnf install ./docker-desktop*-x86_64.rpm

# Install Chromium
sudo dnf install chromium

# Install PHP
sudo dnf install http://rpms.remirepo.net/fedora/remi-release-40.rpm -y
sudo dnf module list php
sudo dnf module enable php:remi-8.2 -y
sudo dnf install php-{fpm,cli,posix,process,mbstring,mcrypt,xml,soap,sodium}

# Install composer
./scripts/composer-install.sh

# Install Devbox
curl -fsSL https://get.jetify.com/devbox | bash
