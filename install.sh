#!/bin/bash

# get either /root or /home/USER depending on the user

DIR=$(if [ "$(id -u)" -eq 0 ]; then echo "/root"; else echo "/home/$(whoami)"; fi)

# create a list of all packages to be installed
packages=(
  tmux
  zsh
  btop
  fzf
  stow
  lsd
  lazygit
  starship
)

# add sources for packages
dnf copr enable -y atim/starship
dnf copr enable -y atim/lazygit

dnf install -y dnf-plugins-core

dnf upgrade --refresh -y

dnf install -y "${packages[@]}"

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

ARCH="$(uname -m)"
case "$ARCH" in
  x86_64)  FILE="nvim-linux64.tar.gz";  DIR="nvim-linux64" ;;
  aarch64) FILE="nvim-linux-arm64.tar.gz"; DIR="nvim-linux-arm64" ;;
  *) echo "Unsupported arch: $ARCH"; exit 1 ;;
esac

# Install latest Neovim (AppImage, x86_64)
curl -fL -o /tmp/nvim.tar.gz "https://github.com/neovim/neovim/releases/latest/download/${FILE}"
tar -xzf /tmp/nvim.tar.gz -C /opt
ln -sf "/opt/${DIR}/bin/nvim" /usr/local/bin/nvim
rm -f /tmp/nvim.tar.gz

stow -t "DIR" neovim

RUNZSH=no KEEP_ZSHRC=yes sh -c "$(wget -O- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

wget -O ~/.oh-my-zsh/custom/themes/agnosterzak.zsh-theme https://raw.githubusercontent.com/zakaziko99/agnosterzak-ohmyzsh-theme/master/agnosterzak.zsh-theme
chsh -s /bin/zsh

# Setup tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo "Starting tmux session..."

tmux new-session -d 'tmux source-file ~/.config/tmux/tmux.conf; tmux run-shell ~/.tmux/plugins/tpm/tpm; tmux kill-session'

tmux attach-session -d

echo "tmux setup and plugin installation complete. tmux will exit automatically once complete."
