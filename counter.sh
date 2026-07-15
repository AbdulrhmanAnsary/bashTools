#!/usr/bin env bash

set -euo pipefail

count=${1:-}

if [[ -z $count ]]; then
  echo "Enter the count number:"
  read count
fi
echo

# Hide the cursor
printf '\e[?25l'

# Make sure the cursor is displayed when the program is finished or you press Ctrl+C
trap 'printf "\e[?25h\n"' EXIT

for ((i = 1; i <= $count; i++)); do
  printf "\r\e[40mCount: %2d\e[0m" "$i"
  sleep 1
done

echo
printf "\nDone!\n"
