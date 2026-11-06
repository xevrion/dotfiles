#!/usr/bin/env bash
# Move every Claude Code session transcript from Fedora to the Mac.
# Separate from pack-claude-for-mac.sh (config, skills, memory) because this one is big:
# ~7.5 GB raw, only ~2x smaller compressed (measured 6 Nov 2026), and /home is nearly full.
# So by default it STREAMS straight to the Mac over SSH and writes nothing to the Lenovo's disk.
#
#   On the Mac first: System Settings > General > Sharing > Remote Login ON,
#   then `ipconfig getifaddr en0` for its IP. Same Wi-Fi/LAN.
#
#   ~/dotfiles/macos/pack-claude-sessions.sh xevrion@<mac-ip>      # stream, recommended
#   ~/dotfiles/macos/pack-claude-sessions.sh --file                # write ~/mac-sessions.tar.gz instead
#
# What moves: ~/.claude/projects (every session .jsonl, subagent + tool-result folders),
# minus memory/ (pack-claude-for-mac.sh already moved it). Folders are renamed
# -home-xevrion-* -> -Users-xevrion-* so each project's sessions land under the right folder.
#
# Transcripts can contain anything ever pasted into a chat (tokens, keys).
# Local network or LocalSend only. Never git, never a cloud drive. Turn Remote Login off after.
set -euo pipefail

SRC="$HOME/.claude"
pack() {
  tar -C "$SRC" -cz \
    --exclude='projects/*/memory' \
    --transform 's,^projects/-home-xevrion,projects/-Users-xevrion,' \
    projects
}

echo "Session data: $(du -sh "$SRC/projects" | cut -f1) raw"

case "${1:-}" in
  --file)
    need_kb=$(( $(du -sk "$SRC/projects" | cut -f1) * 6 / 10 ))   # ~60% of raw, measured ~52%
    free_kb=$(df -k "$HOME" | awk 'NR==2{print $4}')
    if (( free_kb < need_kb + 2*1024*1024 )); then
      echo "Not enough free space in \$HOME (need ~$((need_kb/1024/1024)) GB + 2 GB spare). Use the stream mode."
      exit 1
    fi
    pack > "$HOME/mac-sessions.tar.gz"
    echo "Done: ~/mac-sessions.tar.gz ($(du -h "$HOME/mac-sessions.tar.gz" | cut -f1))"
    echo "On the Mac: tar -xzf ~/Downloads/mac-sessions.tar.gz -C ~/.claude"
    ;;
  "")
    echo "Usage: $0 xevrion@<mac-ip>   (or --file)"; exit 1 ;;
  *)
    echo "Streaming to $1:~/.claude ..."
    pack | ssh "$1" 'mkdir -p ~/.claude && tar -xzf - -C ~/.claude'
    echo "Done. On the Mac: ls ~/.claude/projects | head"
    ;;
esac
