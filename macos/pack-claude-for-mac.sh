#!/usr/bin/env bash
# Run on FEDORA. Packs Claude Code config, skills, plugins and memories for the Mac.
#
#   ~/dotfiles/macos/pack-claude-for-mac.sh            # -> ~/mac-transfer.tar.gz
#
# Then send ~/mac-transfer.tar.gz with LocalSend and on the Mac:
#   tar -xzf mac-transfer.tar.gz -C ~
#   rsync -a ~/mac-transfer/claude/ ~/.claude/
#   rsync -a ~/mac-transfer/agents/ ~/.agents/
#   claude          # log in again, credentials are never copied
#
# What it does:
#   - copies ~/.claude minus sessions, caches, logs, credentials, Linux-only bits
#   - copies every project's memory/ folder, renamed /home/xevrion -> /Users/xevrion
#   - copies ~/.agents (skill sources) minus Python venvs and node_modules
#   - rewrites /home/xevrion -> /Users/xevrion in config files and symlinks
set -euo pipefail

OUT="${1:-$HOME/mac-transfer}"
MAC_HOME="/Users/xevrion"

rm -rf "$OUT" "$OUT.tar.gz"
mkdir -p "$OUT/claude/projects" "$OUT/agents"

echo "==> ~/.claude config, skills, agents, commands, plugins"
rsync -a \
  --exclude 'projects/' --exclude '.credentials.json' \
  --exclude 'cache/' --exclude 'debug/' --exclude 'file-history/' --exclude 'jobs/' \
  --exclude 'telemetry/' --exclude 'shell-snapshots/' --exclude 'session-env/' \
  --exclude 'sessions/' --exclude 'paste-cache/' --exclude 'backups/' --exclude 'ide/' \
  --exclude 'daemon/' --exclude 'worktrees/' --exclude 'tasks/' --exclude 'uploads/' \
  --exclude 'chrome/' --exclude '*.log' --exclude '*.bak' \
  "$HOME/.claude/" "$OUT/claude/"

echo "==> memories (renamed for /Users/xevrion)"
count=0
for mem in "$HOME"/.claude/projects/*/memory; do
  [[ -d "$mem" ]] || continue
  proj="$(basename "$(dirname "$mem")")"
  [[ "$proj" == -home-xevrion* ]] || continue   # skip memories from /tmp scratch paths
  newproj="${proj/#-home-xevrion/-Users-xevrion}"
  mkdir -p "$OUT/claude/projects/$newproj"
  rsync -a "$mem" "$OUT/claude/projects/$newproj/"
  count=$((count + 1))
done
echo "    $count memory folders"

echo "==> ~/.agents (skill sources, no venvs)"
rsync -a --exclude '.venv*/' --exclude 'venv/' --exclude 'node_modules/' --exclude '__pycache__/' \
  --exclude 'ms-playwright/' \
  "$HOME/.agents/" "$OUT/agents/"
echo "    (venvs and Playwright browsers are Linux builds: recreate them on the Mac)"

echo "==> rewriting /home/xevrion -> $MAC_HOME in text files"
grep -rlI "/home/xevrion" "$OUT" 2>/dev/null | while read -r f; do
  sed -i "s|/home/xevrion|$MAC_HOME|g" "$f"
done

echo "==> fixing absolute symlinks"
find "$OUT" -type l | while read -r link; do
  target="$(readlink "$link")"
  case "$target" in
    /home/xevrion/*) ln -sfn "$MAC_HOME${target#/home/xevrion}" "$link" ;;
  esac
done

echo "==> archive"
tar -czf "$OUT.tar.gz" -C "$(dirname "$OUT")" "$(basename "$OUT")"
du -sh "$OUT" "$OUT.tar.gz"

echo
echo "Linux-only commands still referenced in settings.json hooks (fix on the Mac):"
grep -o -E 'notify-send|xclip|wl-copy|wl-paste|xdg-open|paplay|aplay|hyprctl|qs -c' "$OUT/claude/settings.json" 2>/dev/null | sort | uniq -c || echo "    none"
