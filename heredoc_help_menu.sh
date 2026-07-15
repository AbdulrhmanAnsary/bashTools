#!/usr/bin/env bash

# Auther: Abdulrhman M. Ansari
# Sources: "https://www.howtogeek.com/beginner-friendly-ways-to-level-up-your-bash-scripts/"

# a sensible help menu, CLI argument parsing, and debugging

[[ -n "$DEBUG" ]] && set -x  # ENABLE DEBUG STATEMENTS via an environment variable e.g. DEBUG=true ./heredoc_help_menu.sh -a foo.

_help() {
  cat <<EOF
Usage: $(basename "$0") [OPTIONS]

OPTIONS
  -h     display this help menu
  -r     do NOT press this button
  -a     echo something
EOF
}

while getopts "ra:h" opt; do
  case "$opt" in
  r)
    curl 'https://ascii.live/rick'
    ;;
  a)
    echo "ECHO -$opt: $OPTARG" # For example, "ECHO -a: foo"
    ;;
  h)
    _help
    exit 0
    ;;
  esac
done
