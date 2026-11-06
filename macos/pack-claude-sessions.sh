#!/usr/bin/env bash
# Pack a SELECTION of Claude Code sessions (and Kennel's tab list) on Fedora for the Mac.
# Separate from pack-claude-for-mac.sh (config, skills, memory).
#
#   ~/dotfiles/macos/pack-claude-sessions.sh            # -> ~/mac-sessions.7z (asks for a password)
#   FULL=1 ~/dotfiles/macos/pack-claude-sessions.sh     # also subagent logs + tool results (much bigger)
#
# Which projects: one per line in ~/.config/mac-transfer/sessions.txt (kept out of this public
# repo on purpose: project names are private). "~" means the home folder itself.
#
# By default only main conversation files (*.jsonl) move: that's what `claude --resume` lists.
# Subagent logs and tool outputs are ~70% of the size and rarely needed.
# Folders are renamed -home-xevrion-* -> -Users-xevrion-* so sessions land under the right project.
# If Kennel's tabs.json exists it comes too, with /home/xevrion rewritten to /Users/xevrion,
# so every Kennel tab opens on the Mac with the same folder and session.
#
# AES-encrypted 7z (file names hidden too): transcripts can contain anything ever pasted into a chat.
#
# On the Mac (brew install sevenzip):
#   7zz x ~/Downloads/mac-sessions.7z -o"$HOME/mac-sessions"
#   rsync -a ~/mac-sessions/projects/ ~/.claude/projects/
#   mkdir -p ~/Library/Application\ Support/kennel && cp ~/mac-sessions/kennel/tabs.json ~/Library/Application\ Support/kennel/
set -euo pipefail

LIST="$HOME/.config/mac-transfer/sessions.txt"
[ -f "$LIST" ] || { echo "Missing $LIST (one project per line)"; exit 1; }

SRC="$HOME/.claude/projects"
STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT
mkdir -p "$STAGE/projects"

while IFS= read -r p; do
  [[ -z "$p" || "$p" == \#* ]] && continue
  [ "$p" = "~" ] && p=""
  from="$SRC/-home-xevrion${p:+-$p}"
  to="$STAGE/projects/-Users-xevrion${p:+-$p}"
  [ -d "$from" ] || { echo "skip (not found): $from"; continue; }
  mkdir -p "$to"
  if [ "${FULL:-0}" = 1 ]; then
    rsync -a --exclude memory/ "$from/" "$to/"
  else
    rsync -a --include='*.jsonl' --exclude='*' "$from/" "$to/"
  fi
done < "$LIST"

KTABS="${XDG_STATE_HOME:-$HOME/.local/state}/kennel/tabs.json"
if [ -f "$KTABS" ]; then
  mkdir -p "$STAGE/kennel"
  sed "s#/home/xevrion#/Users/xevrion#g" "$KTABS" > "$STAGE/kennel/tabs.json"
  echo "Kennel tabs: $(grep -o '"session"' "$KTABS" | wc -l) included"
fi

echo "Staged: $(du -sh "$STAGE" | cut -f1), $(find "$STAGE/projects" -name '*.jsonl' | wc -l) transcripts"
rm -f "$HOME/mac-sessions.7z"
(cd "$STAGE" && 7z a -p -mhe=on -mx=7 "$HOME/mac-sessions.7z" projects $( [ -d kennel ] && echo kennel ) >/dev/null)
echo "Done: ~/mac-sessions.7z ($(du -h "$HOME/mac-sessions.7z" | cut -f1)). Upload to Drive, delete it from Drive once it's on the Mac."
