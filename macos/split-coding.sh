#!/usr/bin/env bash
# Run on FEDORA. Splits ~/Coding into hot (touched recently) and cold folders,
# so only hot ones go to the Mac and cold ones become one archive.
#
#   ~/dotfiles/macos/split-coding.sh            # 60-day cutoff
#   ~/dotfiles/macos/split-coding.sh 90         # 90-day cutoff
#
# Writes ~/mac-transfer/hot.txt and ~/mac-transfer/cold.txt (one folder per line),
# then prints the rsync and tar commands to use with them.
# Measured 30 Oct 2026: 61 hot folders (27 GB), 171 cold (9 GB), deps excluded.
set -euo pipefail

DAYS="${1:-60}"
SRC="$HOME/Coding"
OUT="$HOME/mac-transfer"
mkdir -p "$OUT"
: > "$OUT/hot.txt"; : > "$OUT/cold.txt"

cutoff=$(date -d "$DAYS days ago" +%s)
cd "$SRC"
for d in */; do
  d="${d%/}"
  last=$(find "$d" \( -name node_modules -o -name target -o -name .next -o -name .venv -o -name .git \) -prune \
           -o -type f -printf '%T@\n' 2>/dev/null | sort -rn | head -1 | cut -d. -f1)
  if [[ -n "$last" && "$last" -ge "$cutoff" ]]; then
    echo "$d" >> "$OUT/hot.txt"
  else
    echo "$d" >> "$OUT/cold.txt"
  fi
done

echo "hot:  $(wc -l < "$OUT/hot.txt") folders  -> $OUT/hot.txt"
echo "cold: $(wc -l < "$OUT/cold.txt") folders -> $OUT/cold.txt"
echo "Edit hot.txt by hand if something cold should still come along."
cat <<EOF

Hot folders to the Mac (Remote Login on, brew rsync installed on the Mac):
  rsync -aH -r --info=progress2 --rsync-path=/opt/homebrew/bin/rsync \\
    --files-from=$OUT/hot.txt \\
    --exclude node_modules/ --exclude target/ --exclude .next/ --exclude .venv/ \\
    --exclude __pycache__/ --exclude .turbo/ \\
    ~/Coding/ xevrion@<mac-ip>:~/Coding/

Cold folders into one archive (keep it on the Lenovo and the backup drive):
  tar -czf ~/coding-cold-\$(date +%F).tar.gz -C ~/Coding \\
    --exclude node_modules --exclude target --exclude .next --exclude .venv \\
    -T $OUT/cold.txt
EOF
