# macOS

Fedora + Hyprland config, ported to the MacBook Pro M6. Same shell, same prompt, same editor, same terminal, same keybind positions.

```sh
git clone https://github.com/xevrion/dotfiles ~/dotfiles
~/dotfiles/macos/bootstrap.sh
```

## Files

| File | Becomes | From |
|---|---|---|
| `Brewfile` | every CLI and app | what's installed on Fedora, names checked on formulae.brew.sh |
| `zshrc` | `~/.zshrc` (symlink) | the live Fedora `~/.zshrc`, Linux-only lines dropped |
| `ghostty.config.local` | `~/.config/ghostty/config.local` | the two Linux-only Ghostty lines, Mac versions |
| `defaults.sh` | macOS settings | key repeat, Dock, Finder, AeroSpace prerequisites |
| `bootstrap.sh` | all of the above, in order | |
| `../aerospace/` | `~/.config/aerospace/aerospace.toml` | `hyprland.conf` binds, same keys with Option as Super |
| `../tmux/` | `~/.tmux.conf` | the live Fedora `~/.tmux.conf` |

## Before leaving Fedora (step 0)

- [ ] **Sync the live Neovim config into the repo.** `~/.config/nvim` is a real folder, not the stowed one, and it's newer (lint fix, cord.lua):
  `rsync -a --exclude '*.log' --exclude '.nvimlog' ~/.config/nvim/ ~/dotfiles/nvim/.config/nvim/`
- [ ] **Commit and push** `macos/`, `aerospace/`, `tmux/`, the Ghostty and gitconfig changes, and the nvim sync.
- [ ] **Secrets:** the Fedora `~/.zshrc` has a token line. Move it to the Mac's `~/.zshrc.local` through Bitwarden or LocalSend. Never through git.
- [ ] **Claude Code:** copy `~/.claude/` minus `projects/`, `sessions/`, `cache/`, `debug/`, `file-history/` (settings, CLAUDE.md, agents, commands, skills, plugins come along). Memory folders are named after the path: `-home-xevrion-brain` becomes `-Users-xevrion-brain` on the Mac. Copy that `memory/` folder across under the new name. Log in again on the Mac.
- [ ] **Vault:** `git clone` the brain repo on the Mac, open the folder in Obsidian.

## Moving everything across

Four things move, four different ways.

### 1. Claude Code (config, 177 skills, agents, commands, plugins, 70 memories): `pack-claude-for-mac.sh`
On Fedora, the day before the move:
```sh
~/dotfiles/macos/pack-claude-for-mac.sh        # -> ~/mac-transfer.tar.gz, about 45 MB
```
It leaves out sessions, caches, logs and **credentials**. It renames every memory folder from `-home-xevrion-*` to `-Users-xevrion-*` so each project finds its memory on the Mac. It rewrites `/home/xevrion` to `/Users/xevrion` in settings, plugins and skill symlinks, and drops the Linux-only Python venvs and Playwright browser from `~/.agents`. Tested 30 Oct: 0 credentials copied, 0 Linux paths left.

Send it with LocalSend, then on the Mac:
```sh
tar -xzf ~/Downloads/mac-transfer.tar.gz -C ~
rsync -a ~/mac-transfer/claude/ ~/.claude/
rsync -a ~/mac-transfer/agents/ ~/.agents/
claude                                         # log in again
```
The SEO skills need their venv and Playwright rebuilt on the Mac: run the claude-seo install script from `~/.agents/claude-seo` once.

### 2. Repos (`~/Coding`): rsync, not git, hot ones only

`split-coding.sh` sorts `~/Coding` into hot (touched in 60 days: 61 folders, 27 GB) and cold (171 folders, 9 GB) and prints the exact rsync and tar commands. Copy the hot ones with `--files-from`. The cold ones go into one archive kept on the Lenovo and the backup drive. The full-copy command below still works if you'd rather bring everything.
Re-cloning loses work: **80 repos have uncommitted changes, 7 have unpushed commits, 16 have no remote at all.** Copy the folder as it is.

Before copying, on Fedora, fix the two case clashes (the Mac disk ignores letter case and would merge them):
- `~/Coding/RESUME` and `~/Coding/resume`, same PDF name inside. Rename one, e.g. `mv ~/Coding/RESUME ~/Coding/RESUME-old`.
- `devlup-woc/Winter-of-Code-Website/src/components` vs `src/Components`. Merge or rename inside that repo.

On the Mac: System Settings > General > Sharing > **Remote Login** on, `brew install rsync` (macOS ships openrsync, which lacks some flags), and get the IP with `ipconfig getifaddr en0`. Both machines on the same Wi-Fi or LAN. Then on Fedora:
```sh
rsync -aH --info=progress2 --rsync-path=/opt/homebrew/bin/rsync \
  --exclude node_modules/ --exclude target/ --exclude .next/ --exclude .venv/ \
  --exclude __pycache__/ --exclude .turbo/ \
  ~/Coding/ xevrion@<mac-ip>:~/Coding/
```
Safe to re-run, it only sends what changed. Turn Remote Login off afterwards. Dependencies get reinstalled per project when it's opened (`pnpm i`, `cargo build`): the Linux builds wouldn't run on the Mac anyway.

### 3. The vault
`git clone` it to `~/brain`. Obsidian settings come with it (`.obsidian/` is in the repo).

### 4. Keys and logins: fresh, never copied
New SSH key on the Mac, added to GitHub and invent.kde.org. `gh auth login`. Bitwarden for passwords. Tokens from the Fedora `~/.zshrc` go into `~/.zshrc.local` by hand.

## On the Mac

- [ ] Account short name **`xevrion`** at setup, so paths are `/Users/xevrion` and configs only differ in `/home` vs `/Users`.
- [ ] Aula F75 into Mac mode: **Fn + E**. Option now sits where Super was.
- [ ] Run `bootstrap.sh`, then the manual list it prints at the end.
- [ ] **Zed:** `settings.json` points stylua and shfmt at `/home/xevrion/.local/share/nvim/mason/bin/`. On the Mac use the brew ones: `"command": "stylua"`, `"command": "shfmt"`.

## What changed between the two machines

| Fedora | Mac | Note |
|---|---|---|
| Hyprland, niri | AeroSpace | Same binds, see the comments in `aerospace.toml` |
| Noctalia bar + widgets | Menu bar + Stats | |
| rofi, Ulauncher, cliphist | Raycast | Option+O launcher, Option+V clipboard |
| grim + slurp | `screencapture`, Shottr | Option+S = region to clipboard |
| hyprpicker | Raycast color picker / Digital Color Meter | |
| Nautilus | Finder | Option+E |
| nvm | fnm | Same `.nvmrc`, faster startup |
| Docker Engine | Colima | Same `docker compose` commands |
| xclip aliases | built-in `pbcopy` / `pbpaste` | |
| EasyEffects Chu 2 Harman preset | Moondrop's own EQ, or eqMac | Linux-only app |
| GTK themes, udiskie, polkit agent | not needed | |
| homelab aliases (`~/homelab/*`) | stay on the Lenovo | Reach it over Tailscale. The LOQ becomes the home server |
| linuxbrew at `/home/linuxbrew/.linuxbrew` | `/opt/homebrew` | |

Stays identical: Ghostty theme, font and keybinds, Oh My Zsh + Powerlevel10k, git config, lazygit, btop, fastfetch, Neovim, Zed, tmux.
