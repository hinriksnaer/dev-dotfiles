export ZSH="$HOME/.oh-my-zsh"

# If using Starship, OMZ theme is ignored; you can comment this out.
ZSH_THEME="agnosterzak"

plugins=(
  git
  dnf
  zsh-autosuggestions
  zsh-syntax-highlighting
)


# Paths
source "$ZSH/oh-my-zsh.sh"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export CLAUDE_CODE_USE_VERTEX=1
export CLOUD_ML_REGION=us-east5
export ANTHROPIC_VERTEX_PROJECT_ID=itpc-gcp-ai-eng-claude
export PYTHONPATH="${PYTHONPATH:+$PYTHONPATH:}/root/workspace/pytorch"

source <(fzf --zsh)

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# lsd aliases
alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

# Prompt (Starship). If you prefer OMZ theme, remove this line.
eval "$(starship init zsh)"

source $HOME/.venv/bin/activate
