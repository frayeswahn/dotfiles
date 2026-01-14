# Dotfiles

Personal shell configuration with oh-my-zsh and starship prompt.

## Quick Start

```bash
git clone <repo-url> ~/dotfiles
cd ~/dotfiles
./setup.sh
exec zsh
```

## What's Included

- **oh-my-zsh** with plugins: git, zsh-autosuggestions, zsh-syntax-highlighting, history, common-aliases, extract, docker, kubectl, z
- **starship** prompt

## Structure

```
dotfiles/
├── setup.sh          # Bootstrap script
└── zsh/
    ├── .zshrc        # Zsh configuration
    └── starship.toml # Starship prompt config
```

