# xevrion's dotfiles

Personal Linux desktop dotfiles built around Fedora, Hyprland, Ghostty, Noctalia, Zsh, and Neovim.

## What's here

- `hyprland/`: Hyprland config, keybinds, monitor layout, screenshots, and Noctalia shell integration
- `ghostty/`: Ghostty terminal config and bundled themes
- `noctalia/`: Noctalia shell settings, colors, and plugin sources
- `nvim/`: Neovim config based on the LazyVim starter
- `rofi/`: Rofi launcher, runner, and powermenu theme/scripts
- `zsh/`: Zsh config with Oh My Zsh and Powerlevel10k
- `wallpapers/`: wallpaper collection for the desktop setup

## Current stack

- OS: Fedora 43
- WM: Hyprland
- Shell: Zsh
- Prompt: Powerlevel10k
- Terminal: Ghostty
- Desktop shell: Noctalia
- Launcher: Rofi
- Editor: Neovim (LazyVim starter)

## Prerequisites

At minimum, install:

- `stow`
- `hyprland`
- `ghostty`
- `zsh`
- `rofi`
- `nvim`

This repo also expects a few extra tools depending on what you use from the config, including:

- `quickshell` / Noctalia
- `wl-clipboard`
- `cliphist`
- `grim`
- `slurp`
- `udiskie`
- `nautilus`
- `polkit-mate`
- `powerlevel10k`
- `oh-my-zsh`

## Install

```bash
git clone https://github.com/xevrion/dotfiles ~/dotfiles
cd ~/dotfiles
stow ghostty hyprland noctalia rofi zsh
stow nvim
```

If you already have conflicting files in `~/.config` or your home directory, back them up first or use:

```bash
stow --adopt ghostty hyprland noctalia rofi zsh nvim
```

## Notes

- `nvim/.config/nvim` is currently the LazyVim starter layout with local changes on top.
- Some values are machine-specific and should be adjusted after install:
  - Hyprland monitor names, resolutions, and placement
  - absolute paths like `/home/xevrion/...`
  - Ghostty shader path
  - terminal commands referenced by Noctalia and Rofi
- Wallpapers are included in `wallpapers/`, but wallpaper selection/loading is not fully wired here beyond the Hyprland side.

## Uninstall

```bash
cd ~/dotfiles
stow -D ghostty hyprland noctalia rofi zsh nvim
```
