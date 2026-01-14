#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🚀 Setting up dotfiles..."
echo ""

# Install zsh if not present
if ! command -v zsh &> /dev/null; then
    echo "📦 Installing zsh..."
    if command -v apt &> /dev/null; then
        sudo apt update && sudo apt install -y zsh
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y zsh
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm zsh
    elif command -v brew &> /dev/null; then
        brew install zsh
    else
        echo "❌ Could not detect package manager. Please install zsh manually."
        exit 1
    fi
else
    echo "✓ zsh already installed"
fi

# Install oh-my-zsh to standard location
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "📦 Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
else
    echo "✓ oh-my-zsh already installed"
fi

# Install zsh plugins
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo "📦 Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
else
    echo "✓ zsh-autosuggestions already installed"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    echo "📦 Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
else
    echo "✓ zsh-syntax-highlighting already installed"
fi

# Install starship to ~/.local/bin (standard user bin)
if [ ! -f "$HOME/.local/bin/starship" ]; then
    echo "📦 Installing starship..."
    mkdir -p "$HOME/.local/bin"
    curl -sS https://starship.rs/install.sh | sh -s -- --yes --bin-dir "$HOME/.local/bin"
else
    echo "✓ starship already installed"
fi

# Backup existing configs (only if they're real files, not symlinks)
backup_if_exists() {
    if [ -f "$1" ] && [ ! -L "$1" ]; then
        echo "📋 Backing up $1 to $1.backup"
        mv "$1" "$1.backup"
    fi
}

backup_if_exists "$HOME/.zshrc"
backup_if_exists "$HOME/.zshenv"
backup_if_exists "$HOME/.config/starship.toml"

# Create portable .zshenv (uses $HOME so it works on any machine/container)
echo "📝 Creating ~/.zshenv..."
cat > "$HOME/.zshenv" << 'EOF'
export ZSH="$HOME/.oh-my-zsh"
export PATH="$HOME/.local/bin:$PATH"
EOF

# Create symlinks
echo "🔗 Creating symlinks..."

ln -sf "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"

mkdir -p "$HOME/.config"
ln -sf "$DOTFILES_DIR/zsh/starship.toml" "$HOME/.config/starship.toml"

# Set zsh as default shell (skip in containers where chsh may not work)
ZSH_PATH="$(which zsh)"
if [ "$SHELL" != "$ZSH_PATH" ]; then
    if command -v chsh &> /dev/null; then
        echo "🐚 Setting zsh as default shell..."
        chsh -s "$ZSH_PATH" 2>/dev/null || echo "   (skipped - chsh not available or requires password)"
    fi
else
    echo "✓ zsh is already the default shell"
fi

echo ""
echo "✅ Done! Run 'exec zsh' to start using your shell."
