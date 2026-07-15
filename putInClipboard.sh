#!/usr/bin/env bash

# Author: Abdulrhman .M Ansary

set -euo pipefail

# Put the text into the clipboard
putInClipboard() {
  if [ $# -gt 0 ]; then
    printf '%s\n' "$*" | tee -a ~/clipboard.txt | termux-clipboard-set
  else
    tee -a ~/clipboard.txt | termux-clipboard-set
  fi
}
