#!/bin/bash

disto="none"

deb_packages=("git" "")

if command -v apt &>/dev/null; then
  sudo apt-get update
  sudo apt install dialog

  distro="deb"

elif command -v pacman &>/dev/null; then
  sudo pacman -Sy
  sudo pacman -S dialog

  distro="arch"
else
  echo "Unable to determine your distro"
  exit 1
fi

down_pkg() {
  if [ "$distro" == "arch" ]; then
    sudo pacman -S "$1"
  fi

  if [ "$distro" == "deb" ]; then
    sudo apt install "$1"
  fi
}

install_all() {
  echo "Installing everything..."

  down_pkg "curl"
  down_pkg "git"
  down_pkg "ripgrep"

  # ZSH
  echo "Installing ZSH"
  down_pkg "zsh"
  chsh -s $(which zsh)

  # Powerlevel10k
  echo "Installing powerlevel10k"
  if command -v zsh &>/dev/null; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    ZSHRC_FILE="$HOME/.zshrc"
    sed -i 's/^ZSH_THEME=".*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' "$ZSHRC_FILE"
  else
    echo "Error: ZSH is not installed, canceling powerlevel10k installation"
  fi

  # LazyVim
  echo "Installing lazyvim"
  down_pkg "neovim"

  mv ~/.config/nvim{,.bak}
  git clone https://github.com/LazyVim/starter ~/.config/nvim
  rm -rf ~/.config/nvim/.git

  # btop
  echo "Installing btop"
  down_pkg "btop"

  # Zsh Plugins
  if command -v zsh &>/dev/null; then
    echo "Installing ZSH plugins"
    git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
    git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
    git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete

    ZSHRC_FILE="$HOME/.zshrc"
    if grep -q '^plugins=\(\)' "$ZSHRC_FILE"; then
      sed -i 's/^plugins=\(\)/plugins=(zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete)/' "$ZSHRC_FILE"
    elif grep -q '^plugins=' "$ZSHRC_FILE"; then
      sed -i '/^plugins=/ s/)/ zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete)/' "$ZSHRC_FILE"
    else
      echo 'plugins=(zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete)' >>"$ZSHRC_FILE"
    fi
  else
    echo "Error: ZSH is not installed, canceling ZSH plugin installation"
  fi
}

normal() {
  install_all
}

main_menu() {
  options=("Option 1" "Option 2" "Option 3" "Quit")
  choice=$(dialog --clear \
    --title "Menu" \
    --menu "Please select an install type:" 15 40 4 \
    1 "Normal install" \
    2 "Custom install" \
    3 "Quit" \
    3>&1 1>&2 2>&3)
  clear
  case $choice in
  1) normal ;;
  2) custom ;;
  3) echo "quit" ;;
  esac
}

main_menu
