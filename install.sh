#!/bin/bash

# get either /root or /home/USER depending on the user

DIR=$(if [ "$(id -u)" -eq 0 ]; then echo "/root"; else echo "/home/$(whoami)"; fi)

# create a list of all packages to be installed
packages=(
  tmux
  neovim
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

RUNZSH=no KEEP_ZSHRC=yes sh -c "$(wget -O- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

wget -O ~/.oh-my-zsh/custom/themes/agnosterzak.zsh-theme https://raw.githubusercontent.com/zakaziko99/agnosterzak-ohmyzsh-theme/master/agnosterzak.zsh-theme
chsh -s /bin/zsh

# Define the path to your tmux configuration file
TMUX_CONFIG="$HOME/.config/tmux/tmux.conf"

# Step 1: Run tmux to initialize it (in case it's not started)
tmux start-server

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Step 2: Start a new tmux session in the background
tmux new-session -d -s temp_session "tmux source-file $TMUX_CONFIG; tmux refresh-client"

# Step 3: Send 'C-Space' + 'I' to trigger the plugin installation (reload) through TPM
tmux send-keys -t temp_session C-Space 'I'
sleep 2
# Step 4: Clean up by killing the temporary tmux session
tmux kill-session -t temp_session
