#!/bin/bash
set -e

# Get either /root or /home/USER depending on the user
DIR=$(if [ "$(id -u)" -eq 0 ]; then echo "/root"; else echo "/home/$(whoami)"; fi)

# Packages to install
packages=(
  ripgrep
  tmux
  zsh
  btop
  fzf
  stow
  lsd
  lazygit
  starship
)

# ---- Privileged installs ----
sudo dnf install -y dnf-plugins-core
sudo dnf copr enable -y atim/starship
sudo dnf copr enable -y atim/lazygit

sudo dnf upgrade --refresh -y
sudo dnf install -y "${packages[@]}"

# Latest Neovim into /opt + /usr/local/bin
curl -fL -o /tmp/nvim.tar.gz "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
sudo tar -xzf /tmp/nvim.tar.gz -C /opt
sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
rm -f /tmp/nvim.tar.gz

# link 
for package in "${packages[@]}"; do 
    # check if file exists 
    if [ ! -d "$package" ]; then 
        echo "Directory $DIR/.config/$package does not exist, skipping stow for $package"
        continue 
    fi 
    echo "Stowing $package in $DIR"
    stow -t "$DIR" "$package" 
done

stow -t "$DIR" neovim

# Install oh-my-zsh (run as user)
RUNZSH=no KEEP_ZSHRC=yes sh -c \
  "$(wget -O- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

wget -O ~/.oh-my-zsh/custom/themes/agnosterzak.zsh-theme \
  https://raw.githubusercontent.com/zakaziko99/agnosterzak-ohmyzsh-theme/master/agnosterzak.zsh-theme

# Change shell for the current user (needs sudo if run inside devcontainer)
if command -v sudo &>/dev/null; then
  sudo chsh -s /bin/zsh "$(whoami)"
else
  chsh -s /bin/zsh
fi

echo "setting up tmux"
# Setup tmux plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Use a private tmux server to avoid needing a TTY
TMUX_SOCK=bootstrap

# Start server, source your config, install plugins, stop server
tmux -L "$TMUX_SOCK" -f /dev/null start-server
tmux -L "$TMUX_SOCK" source-file "$HOME/.config/tmux/tmux.conf" || true
"$HOME/.tmux/plugins/tpm/bin/install_plugins" || true
tmux -L "$TMUX_SOCK" kill-server
echo "tmux setup complete."
