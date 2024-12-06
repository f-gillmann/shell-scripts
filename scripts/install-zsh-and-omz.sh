#!/bin/bash
detect_package_manager() {
  if [ -x "$(command -v apt)" ]; then
    echo "apt"
  elif [ -x "$(command -v yum)" ]; then
    echo "yum"
  elif [ -x "$(command -v dnf)" ]; then
    echo "dnf"
  elif [ -x "$(command -v pacman)" ]; then
    echo "pacman"
  elif [ -x "$(command -v brew)" ]; then
    echo "brew"
  else
    echo "none"
  fi
}

# check which package manager is being used by the system
pkg_manager=$(detect_package_manager)

# if no supported package manager is detected, exit
if [ "$pkg_manager" = "none" ]; then
  echo "No supported package manager detected. Exiting."
  exit 1
fi

# check if git and curl are installed
if ! command -v git &> /dev/null; then
  echo "Error: git is not installed. Please install git before running this script."
  exit 1
fi

if ! command -v curl &> /dev/null; then
  echo "Error: curl is not installed. Please install curl before running this script."
  exit 1
fi

# prompt for confirmation (default: no)
read -p "Do you want to install Zsh using $pkg_manager? (y/N): " confirm
confirm=${confirm:-N}
if [[ "$confirm" =~ ^([yY][eE][sS]|[yY])$ ]]; then
  echo "Proceeding with Zsh installation..."
else
  echo "Installation cancelled by user."
  exit 0
fi

# install zsh using the detected package manager
if [ "$pkg_manager" = "apt" ]; then
  sudo apt update
  sudo apt install -y zsh
elif [ "$pkg_manager" = "yum" ]; then
  sudo yum install -y zsh
elif [ "$pkg_manager" = "dnf" ]; then
  sudo dnf install -y zsh
elif [ "$pkg_manager" = "pacman" ]; then
  sudo pacman -S --noconfirm zsh
elif [ "$pkg_manager" = "brew" ]; then
  brew install zsh
fi

# verify if zsh is installed
if ! command -v zsh &> /dev/null; then
  echo "Zsh installation failed. Exiting."
  exit 1
fi

# install Oh My Zsh
echo "Installing Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "Oh My Zsh is already installed."
fi

echo "Installation completed!"

