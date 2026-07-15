#!/data/data/com.termux/files/usr/bin/bash

# Author: Abdulrhman Ansary
# Modify date: 21 February 2025

# Select the folder that contains backups
BACKUP_DIR="$HOME/.backup"

# Set the default retention period if no argument is provided
if [ -z "$1" ]; then
  BACKUP_TIME="+3"
elif [[ "$1" =~ ^[0-9]+$ ]]; then
  if [ "$1" -eq 0 ]; then
    BACKUP_TIME="0" # Delete only modified files today
  else
    BACKUP_TIME="+$1" # Delete files older than n day
  fi
else
  echo "Error: Invalid input. Please enter a valid number of days."
  exit 1
fi

# Ensure the backup directory exists
if [ ! -d "$BACKUP_DIR" ]; then
  echo "Error: Backup directory $BACKUP_DIR does not exist."
  exit 1
fi

# Delete files based on the retention period
if [ "$BACKUP_TIME" = "0" ]; then
  find "$BACKUP_DIR" -type f -mtime 0 -exec rm -f {} \; 2>/dev/null
else
  find "$BACKUP_DIR" -type f -mtime "$BACKUP_TIME" -exec rm -f {} \; 2>/dev/null
fi

# Notify the user
echo "Cleanup complete: Removed files older than $BACKUP_TIME days from $BACKUP_DIR."
