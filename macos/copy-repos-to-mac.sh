#!/usr/bin/env bash
# Copy the repos you actually work on from Fedora to the Mac, exactly as they are:
# uncommitted changes, unpushed commits and non-git folders included. Dependencies and
# build output are skipped (they're Linux builds; reinstall with pnpm i / cargo build).
#
# Which repos: one path per line (relative to ~/Coding) in ~/.config/mac-transfer/repos.txt,
# kept out of this public repo on purpose.
#
# On the Mac first: System Settings > General > Sharing > Remote Login ON, `brew install rsync`,
# `ipconfig getifaddr en0`. Same Wi-Fi/LAN. Then on Fedora:
#   ~/dotfiles/macos/copy-repos-to-mac.sh xevrion@<mac-ip>
# Safe to re-run: only sends what changed. Turn Remote Login off afterwards.
set -euo pipefail

LIST="$HOME/.config/mac-transfer/repos.txt"
EXCL="$HOME/.config/mac-transfer/exclude.txt"   # extra excludes (agent worktrees, caches, big traces); optional
[ -f "$EXCL" ] || EXCL=""
[ -f "$LIST" ] || { echo "Missing $LIST"; exit 1; }
[ $# -eq 1 ] || { echo "Usage: $0 xevrion@<mac-ip>"; exit 1; }

grep -v '^\s*#' "$LIST" | grep -v '^\s*$' > "${TMPDIR:-/tmp}/mac-repos.$$"
trap 'rm -f "${TMPDIR:-/tmp}/mac-repos.$$"' EXIT

cd "$HOME/Coding"
rsync -aH --info=progress2 --rsync-path=/opt/homebrew/bin/rsync \
  --files-from="${TMPDIR:-/tmp}/mac-repos.$$" -r \
  --exclude node_modules/ --exclude target/ --exclude .next/ --exclude .venv/ \
  --exclude __pycache__/ --exclude .turbo/ --exclude dist/ --exclude .svelte-kit/ \
  ${EXCL:+--exclude-from="$EXCL"} \
  ./ "$1:~/Coding/"
echo "Done. On the Mac: ls ~/Coding"
