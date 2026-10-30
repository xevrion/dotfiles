#!/usr/bin/env bash
# One-shot Mac setup from this dotfiles repo. Safe to re-run.
#
#   git clone https://github.com/xevrion/dotfiles ~/dotfiles
#   ~/dotfiles/macos/bootstrap.sh
#
# What it does, in order:
#   Xcode CLT -> Homebrew -> Brewfile -> Oh My Zsh + p10k + plugins
#   -> stow the shared configs -> zshrc + ghostty local -> Node via fnm
#   -> Touch ID for sudo -> macOS defaults
set -euo pipefail

DOT="$HOME/dotfiles"
say() { printf '\n\033[1;35m==> %s\033[0m\n' "$*"; }

[[ "$(uname)" == "Darwin" ]] || { echo "This script is for macOS."; exit 1; }

say "Xcode Command Line Tools"
if ! xcode-select -p >/dev/null 2>&1; then
  xcode-select --install
  echo "Finish the popup installer, then re-run this script."
  exit 0
fi

say "Homebrew"
if ! command -v brew >/dev/null 2>&1 && [[ ! -x /opt/homebrew/bin/brew ]]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

say "Brewfile (this one takes a while)"
if ! brew bundle install --file "$DOT/macos/Brewfile"; then
  echo "Some items failed. If a third-party tap was refused, trust it once"
  echo "(see https://docs.brew.sh/Tap-Trust), then re-run this script."
fi

say "Oh My Zsh + Powerlevel10k + plugins (same as Fedora)"
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi
ZC="$HOME/.oh-my-zsh/custom"
[[ -d "$ZC/themes/powerlevel10k" ]] || git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZC/themes/powerlevel10k"
[[ -d "$ZC/plugins/zsh-autosuggestions" ]] || git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$ZC/plugins/zsh-autosuggestions"
[[ -d "$ZC/plugins/zsh-syntax-highlighting" ]] || git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting "$ZC/plugins/zsh-syntax-highlighting"

say "Stow the shared configs"
cd "$DOT"
for pkg in ghostty git lazygit nvim zed btop fastfetch aerospace tmux; do
  if stow --no-folding "$pkg" 2>/dev/null; then
    echo "  stowed $pkg"
  else
    echo "  conflict in $pkg: move the existing file aside, or run: stow --adopt $pkg"
  fi
done

say "zshrc, p10k, ghostty local config"
if [[ -f "$HOME/.zshrc" && ! -L "$HOME/.zshrc" ]]; then
  mv "$HOME/.zshrc" "$HOME/.zshrc.before-dotfiles"
fi
ln -sf "$DOT/macos/zshrc" "$HOME/.zshrc"
ln -sf "$DOT/zsh/.p10k.zsh" "$HOME/.p10k.zsh"
[[ -f "$HOME/.zshrc.local" ]] || printf '# Secrets and machine-only lines. Never commit this file.\n' > "$HOME/.zshrc.local"
mkdir -p "$HOME/.config/ghostty"
[[ -f "$HOME/.config/ghostty/config.local" ]] || cp "$DOT/macos/ghostty.config.local" "$HOME/.config/ghostty/config.local"

say "Node via fnm (Fedora had 22 as default, 26 installed)"
eval "$(fnm env --shell bash)"
fnm install 22 && fnm install 26 && fnm default 22

say "Touch ID for sudo (survives macOS updates)"
if [[ ! -f /etc/pam.d/sudo_local ]]; then
  sed -e 's/^#auth/auth/' /etc/pam.d/sudo_local.template | sudo tee /etc/pam.d/sudo_local >/dev/null
  echo "  done, next sudo asks for your finger"
fi

say "macOS defaults"
bash "$DOT/macos/defaults.sh"

say "Done. Manual steps left:"
cat <<'EOF'
  1. Log out and back in (key repeat, Spaces setting).
  2. Open AeroSpace, Raycast, Karabiner, AltTab, LinearMouse: grant Accessibility when asked.
  3. Karabiner: Complex Modifications > Add predefined rule > "Caps Lock to Escape/Control".
  4. Raycast: hotkey Cmd+Space (turn off Spotlight's), Option+O launcher, Option+V clipboard history.
  5. System Settings > Displays: set the M27QA as Main, 180Hz. Battery: Charge Limit 80%.
  6. gh auth login, then: ssh-keygen -t ed25519 and add the key to GitHub + invent.kde.org.
  7. Put tokens from the Fedora ~/.zshrc into ~/.zshrc.local.
  8. rustup default stable   |   colima start --cpu 4 --memory 8 --vm-type=vz --vz-rosetta
  9. Full checklist: ~/dotfiles/macos/README.md
EOF
