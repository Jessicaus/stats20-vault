#!/bin/zsh
# Double-click to start the Stats 20 dashboard, then open the Dashboard note in Obsidian.
cd "$(dirname "$0")" || exit 1
Rscript r/run-dashboard.R
