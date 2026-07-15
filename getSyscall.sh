#!/bin/bash
# Author: Abdulrhman Ansary (with improvements)
# Syscall Number Finder
# This script takes one or more syscall names as input and prints their corresponding syscall numbers.
# It looks up definitions in /data/data/com.termux/files/usr/include/asm-generic/unistd.h
#
# Usage:
#   ./get_syscall.sh write read open

HEADER="/data/data/com.termux/files/usr/include/asm-generic/unistd.h"

# Check if the header file exists
if [ ! -f "$HEADER" ]; then
  echo "Error: Header file not found at $HEADER. Please verify your Termux installation."
  exit 1
fi

# If no syscall name is provided, display usage and a list of available syscalls
if [ "$#" -eq 0 ]; then
  echo "Usage: $(basename $0) syscall_name [syscall_name ...]"
  echo "Available syscalls:"
  grep -E "^\s*#\s*define\s+__NR_" "$HEADER" | awk '{print $2, $3}'
  exit 1
fi

# Loop through each syscall name provided as an argument
for SYSCALL in "$@"; do
  # Look for the line that defines the syscall (e.g., #define __NR_write 1)
  LINE=$(grep -m1 -E "^\s*#\s*define\s+__NR_${SYSCALL}\b" "$HEADER")

  if [ -z "$LINE" ]; then
    echo "Syscall '${SYSCALL}' not found."
  else
    # Extract the syscall number (assumed to be the third token in the line)
    NUMBER=$(echo "$LINE" | awk '{print $3}')
    echo "${SYSCALL}: ${NUMBER}"
  fi
done
