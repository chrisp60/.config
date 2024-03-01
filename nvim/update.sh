set -e

URL=https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz
curl -LO $URL
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz
rm nvim-linux64.tar.gz
