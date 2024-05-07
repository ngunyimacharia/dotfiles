# Install Google Chrome
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmour -o /usr/share/keyrings/chrome-keyring.gpg
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/chrome-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list'
sudo apt update
sudo apt install google-chrome-stable -y

# Install Slack
flatpak install flathub com.slack.Slack -y

# Install Zoom
flatpak install flathub us.zoom.Zoom -y

# Install MS Teams
sudo snap install teams-for-linux

# Install Spotify
flatpak install flathub com.spotify.Client
