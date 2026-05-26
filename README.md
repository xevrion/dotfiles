# dotfiles

Personal Linux desktop config, built around Fedora, Hyprland, and Ghostty.

## Stack

| Role | Tool |
|---|---|
| OS | Fedora 43 |
| WM | Hyprland |
| Terminal | Ghostty |
| Shell | Zsh + Oh My Zsh + Powerlevel10k |
| Desktop shell | Noctalia (Quickshell) |
| Launcher | Rofi |
| Editor | Neovim |
| Font | JetBrains Mono |
| Theme | Catppuccin Mocha |

## Structure

Each directory is a [stow](https://www.gnu.org/software/stow/) package. Running `stow <pkg>` from the repo root symlinks the package contents into `~`.

```
btop/        btop config
cava/        cava visualizer config + shaders
fastfetch/   fastfetch config + image
fish/        fish shell config
ghostty/     ghostty terminal config + themes
git/         .gitconfig
gtk-3.0/     GTK3 theme settings
gtk-4.0/     GTK4 theme settings
hyprland/    hyprland.conf + hyprpaper.conf
lazygit/     lazygit config
noctalia/    Noctalia / Quickshell shell settings + color scheme
nvim/        Neovim config
rofi/        rofi launcher, runner, and powermenu
wallpapers/  wallpaper collection
zed/         Zed editor settings
zsh/         .zshrc + Powerlevel10k config
```

## Install

```sh
git clone https://github.com/xevrion/dotfiles ~/dotfiles
cd ~/dotfiles
./install.sh
```

Or manually stow whatever packages you want:

```sh
cd ~/dotfiles
stow zsh ghostty nvim hyprland rofi
```

If stow complains about existing files, back them up first or use `--adopt` to fold them in.

## Prerequisites

Core:

- `stow`
- `zsh` + `oh-my-zsh` + `powerlevel10k`
- `zsh-autosuggestions`, `zsh-syntax-highlighting`
- `hyprland` + `hyprpaper`
- `ghostty`
- `nvim`
- `rofi`

Optional (for full setup):

- `quickshell` (for Noctalia)
- `btop`, `cava`, `fastfetch`
- `lazygit`
- `fish`
- `zed`
- `wl-clipboard`, `cliphist`
- `grim`, `slurp`
- `udiskie`, `nautilus`
- `polkit-mate`

## Notes

- The ghostty config references an absolute path for a custom shader — update or remove that line after install.
- Hyprland monitor names, resolutions, and workspace layout are machine-specific — adjust after install.
- The `.gitconfig` includes KDE invent.kde.org URL rewrites — remove those if you don't work on KDE.
