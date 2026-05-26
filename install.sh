#!/usr/bin/env bash
set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v stow &>/dev/null; then
  echo "stow is not installed. Install it and re-run."
  exit 1
fi

cd "$DOTFILES"

PACKAGES=(
  btop
  cava
  fastfetch
  fish
  ghostty
  git
  gtk-3.0
  gtk-4.0
  hyprland
  lazygit
  noctalia
  nvim
  rofi
  zed
  zsh
)

for pkg in "${PACKAGES[@]}"; do
  if stow --no-folding "$pkg" 2>/dev/null; then
    echo "  stowed $pkg"
  else
    echo "  conflict in $pkg — run: stow --adopt $pkg  (merges existing files in)"
  fi
done

echo
echo "Done. Edit ghostty/hyprland configs for machine-specific paths."
