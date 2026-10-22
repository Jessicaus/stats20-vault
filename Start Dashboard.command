#!/bin/zsh -l
# Double-click to start the Stats 20 dashboard, then open the Dashboard note in Obsidian.
cd "$(dirname "$0")" || exit 1

if curl -s -o /dev/null http://127.0.0.1:3838; then
  echo "The dashboard is already running at http://127.0.0.1:3838"
  echo "Open the Dashboard note in Obsidian. You can close this window."
  exit 0
fi

RSCRIPT="$(command -v Rscript || echo /usr/local/bin/Rscript)"
"$RSCRIPT" r/run-dashboard.R
