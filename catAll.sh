#!/usr/bin/env bash

# Author: Abdulrahman M. Ansary

set -euo pipefail

# Default options
recursive=false
all=false
hidden=false
target="file"
path="."
extensions=""
exclude=""

# Parse command-line options
while getopts ":radfhp:e:x:" opt; do
    case "$opt" in
        r)
            recursive=true
            ;;
        a)
            all=true
            ;;
        h)
            hidden=true
            ;;
        d)
            target="directory"
            ;;
        f)
            target="file"
            ;;
        p)
            path="$OPTARG"
            ;;
        e)
            extensions="$OPTARG"
            ;;
        x)
            exclude="$OPTARG"
            ;;
        *)
            echo "Usage: $0 [-r] [-a] [-h] [-f|-d] [-p path] [-e ext1,ext2] [-x name1,name2]"
            exit 1
            ;;
    esac
done

shift $((OPTIND - 1))

# Validate the target path
if [[ ! -d "$path" ]]; then
    echo "Error: '$path' is not a valid directory."
    exit 1
fi

# Build the find command
find_args=("$path")

# Search only the current directory unless recursive mode is enabled
if ! "$recursive"; then
    find_args+=(-maxdepth 1)
fi

# Filter hidden or non-hidden entries
if "$all"; then
    :
elif "$hidden"; then
    find_args+=(-name '.*')
else
    find_args+=(! -name '.*')
fi

# Select files or directories
if [[ "$target" == "file" ]]; then
    find_args+=(-type f)
else
    find_args+=(-type d)
fi

# Filter files by extension
if [[ "$target" == "file" && -n "$extensions" ]]; then
    IFS=',' read -ra ext_list <<< "$extensions"

    find_args+=("(")

    first=true
    for ext in "${ext_list[@]}"; do
        if ! "$first"; then
            find_args+=(-o)
        fi
        first=false

        find_args+=(-iname "*.${ext}")
    done

    find_args+=(")")
fi

# Exclude files or directories by name
if [[ -n "$exclude" ]]; then
    IFS=',' read -ra exclude_list <<< "$exclude"

    for name in "${exclude_list[@]}"; do
        find_args+=(! -path "*/${name}")
        find_args+=(! -path "*/${name}/*")
        find_args+=(! -name "$name")
    done
fi

find_args+=(-print0)

# Find matching entries and display them
find "${find_args[@]}" |
while IFS= read -r -d '' item; do
    printf '\n\033[1;33m========================================\n'
    printf '%s: %s\n' "${target^^}" "$item"
    printf '========================================\033[0m\n\n'

    # Display file contents only when searching for files
    if [[ "$target" == "file" ]]; then
        cat "$item"
    fi

    echo
done
