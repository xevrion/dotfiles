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
| Launcher | Rofi / Ulauncher |
| Editor | Neovim / Zed / Sublime Text |
| Font | JetBrains Mono |
| Theme | Catppuccin Mocha |

## Structure

Each directory is a [stow](https://www.gnu.org/software/stow/) package. Running `stow <pkg>` from the repo root symlinks the package contents into `~`.

```
btop/           btop config
cava/           cava visualizer config + shaders
easyeffects/    EasyEffects output EQ presets (e.g. Chu2 Harman)
fastfetch/      fastfetch config + image
fish/           fish shell config
ghostty/        ghostty terminal config + themes
git/            global gitignore (~/.config/git/ignore)
gtk-3.0/        GTK3 theme CSS + settings
gtk-4.0/        GTK4 theme CSS + settings
hyprland/       hyprland.conf + hyprpaper.conf
lazygit/        lazygit config
noctalia/       Noctalia / Quickshell shell settings + color scheme
nvim/           Neovim (LazyVim) config
rofi/           rofi launcher, runner, and powermenu
sublime-text/   Sublime Text User packages (keymaps, preferences, build system, snippets)
ulauncher/      Ulauncher settings, shortcuts, and custom themes
wallpapers/     wallpaper collection
zed/            Zed editor settings + themes
zsh/            .zshrc + Powerlevel10k config
```

### Notes on partial stow packages

- **easyeffects** — only output presets are tracked; the rest of the dir is runtime state. Manually copy presets into `~/.config/easyeffects/output/` after install.
- **sublime-text** — only `Packages/User/` is symlinked. ST writes runtime data elsewhere in `~/.config/sublime-text/`, which is left untouched.
- **ulauncher** — `settings.json`, `shortcuts.json`, and `user-themes/` are symlinked. `extensions.json` is excluded (machine-specific extension state).

## Install

```sh
git clone https://github.com/xevrion/dotfiles ~/dotfiles
cd ~/dotfiles
./install.sh
```

Or manually stow whatever packages you want:

```sh
cd ~/dotfiles
stow zsh ghostty nvim hyprland rofi zed lazygit btop cava fish
stow sublime-text ulauncher gtk-3.0 gtk-4.0 git fastfetch
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
- `sublime-text` (install via official repo)
- `ulauncher`
- `easyeffects`
- `wl-clipboard`, `cliphist`
- `grim`, `slurp`
- `udiskie`, `nautilus`
- `polkit-mate`

## Notes

- The ghostty config references an absolute path for a custom shader — update or remove that line after install.
- Hyprland monitor names, resolutions, and workspace layout are machine-specific — adjust after install.
- The `.gitconfig` includes KDE invent.kde.org URL rewrites — remove those if you don't work on KDE.
