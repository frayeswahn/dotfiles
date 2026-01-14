# Path to oh-my-zsh installation (set in ~/.zshenv)
export ZSH="${ZSH:-$HOME/.oh-my-zsh}"

# Theme (disabled - using starship instead)
ZSH_THEME=""

# Plugins
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  history
  common-aliases
  extract
  docker
  kubectl
  z
)

# Load oh-my-zsh
source $ZSH/oh-my-zsh.sh

# User configuration
export EDITOR='vim'
export LANG=en_US.UTF-8

# Aliases
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'

# Initialize starship prompt
eval "$(starship init zsh)"

