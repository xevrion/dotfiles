#!/usr/bin/env bash
# Pack a SELECTION of Claude Code session transcripts on Fedora for the Mac.
# Separate from pack-claude-for-mac.sh (config, skills, memory).
#
#   ~/dotfiles/macos/pack-claude-sessions.sh            # -> ~/mac-sessions.7z (asks for a password)
#   FULL=1 ~/dotfiles/macos/pack-claude-sessions.sh     # also subagent logs + tool results (much bigger)
#
# By default only the main conversation files (*.jsonl) move: that's what `claude --resume` lists.
# Subagent logs and saved tool outputs are 70%+ of the size and rarely needed.
# Measured 6 Nov 2026: the list below is 7.6 GB with everything, 2.1 GB main transcripts only.
#
# Folders are renamed -home-xevrion-* -> -Users-xevrion-* so sessions land under the right project.
# The archive is AES-encrypted (7z, file names hidden too) because transcripts can contain
# anything ever pasted into a chat. Fine to put on Google Drive that way.
#
# On the Mac: download it, open with Keka (in the Brewfile) or `brew install sevenzip`, then
#   7zz x ~/Downloads/mac-sessions.7z -o"$HOME/mac-sessions" && rsync -a ~/mac-sessions/projects/ ~/.claude/projects/
set -euo pipefail

# Edit this list to add or drop projects. Names are the part after -home-xevrion-.
PROJECTS=(
  ""                     # ~ itself (general sessions started in the home folder)
  brain
  Coding-postcraft
  Coding-psdlift
  Coding-browser-game
  Coding-inplace-extract
  Coding-sys-sim
  Coding-workers-io
  Coding-nomacneeded
  Coding-thy-xev
  Coding-kennel
  Coding-hoard
  Coding-launchmaxxing
  Coding-shaza
  Coding-gyotaku
  Coding-resume
  Coding-codepair
  Coding-clock-by-side
  Coding-tesla-game
  Coding-claude-skill-meme-making
  Coding-multiplayer-games
  Coding-ui-lab
  Coding-Open-Source-tt-metal
  Coding-Open-Source-temporal
  Coding-iitj-5th-sem-coa-lab-ChampSim-master
  Coding-iitj-5th-sem-operating-systems-lab-xv6-public
  Coding-iitj-5th-sem-DBMS-lab-group-project
)

SRC="$HOME/.claude/projects"
STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT
mkdir -p "$STAGE/projects"

for p in "${PROJECTS[@]}"; do
  from="$SRC/-home-xevrion${p:+-$p}"
  to="$STAGE/projects/-Users-xevrion${p:+-$p}"
  [ -d "$from" ] || { echo "skip (not found): $from"; continue; }
  mkdir -p "$to"
  if [ "${FULL:-0}" = 1 ]; then
    rsync -a --exclude memory/ "$from/" "$to/"
  else
    rsync -a --include='*.jsonl' --exclude='*' "$from/" "$to/"
  fi
done

echo "Staged: $(du -sh "$STAGE/projects" | cut -f1), $(find "$STAGE/projects" -name '*.jsonl' | wc -l) transcripts"
rm -f "$HOME/mac-sessions.7z"
7z a -p -mhe=on -mx=7 "$HOME/mac-sessions.7z" "$STAGE/projects" >/dev/null
echo "Done: ~/mac-sessions.7z ($(du -h "$HOME/mac-sessions.7z" | cut -f1)). Upload it to Drive, delete it from Drive once it's on the Mac."
