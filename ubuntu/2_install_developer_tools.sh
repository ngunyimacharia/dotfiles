# Install Oh My Zsh
sudo apt install zsh -y
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Kitty
sudo apt install kitty -y

# Install Neovim
sudo apt install neovim -y

# Install LazyGit 
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin

# Install Pyenv
curl https://pyenv.run | bash

# Install Docker Desktop
# Setup package repository
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
# Install using: https://docs.docker.com/desktop/install/ubuntu/#install-docker-desktop
# Post install instructions: https://docs.docker.com/engine/install/linux-postinstall/
# Ubuntu 24.04 Docker dekstop issue: https://github.com/docker/desktop-linux/issues/209

# Install PHP
sudo apt install software-properties-common -y
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update
sudo apt install php8.3 -y
sudo apt install php8.3-{cli,pdo,mysql,zip,gd,mbstring,curl,xml,bcmath,common}

# Install Nginx 
sudo add-apt-repository -y ppa:nginx/stable
sudo apt-get update

# Install Composer
cd ~
curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php
HASH=`curl -sS https://composer.github.io/installer.sig`
echo $HASH
php -r "if (hash_file('SHA384', '/tmp/composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
sudo php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer

# Install Devbox
curl -fsSL https://get.jetify.com/devbox | bash

# Install Yarn
 sudo npm install --global yarn --force

 # Install TablePlus
wget -qO - https://deb.tableplus.com/apt.tableplus.com.gpg.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/tableplus-archive.gpg > /dev/null
sudo add-apt-repository "deb [arch=amd64] https://deb.tableplus.com/debian/22 tableplus main"
sudo apt update
sudo apt install tableplus -y

# Install Flyctl
curl -L https://fly.io/install.sh | sh

# Install Turso CLI
curl -sSfL https://get.tur.so/install.sh | bash
