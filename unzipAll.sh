#!/usr/bin/env bash

# ------------------------------------------------------------
# Author: Abdulrhman Ansary
# Modification time: 6 march 2025

# Function: unzip_all
# Description:
# This function scans for all ZIP files in the current directory and extracts
# each file into a dedicated subdirectory within the specified target directory.
#
# Function behavior:
# - For each found ZIP file:
#   1. The base name of the file is extracted (removing the .zip extension).
#   2. A subdirectory with the base name is created inside the target directory.
#   3. The ZIP file contents are extracted into the created subdirectory.
#
# - If no ZIP files are found, a message is displayed.
#
# Parameters:
#   - target_dir: The directory where the files will be extracted.
#                 If not provided, the current directory will be used as the default.
#
# Example usage:
#   ./unzipAll.sh [target_directory]
#
# Note:
# This script helps keep extracted files organized in separate folders, 
# preventing conflicts with other existing files or directories.
# ------------------------------------------------------------

unzip_all() {
	local target_dir="$1"

	# Check if there are any ZIP files in the current directory
	if ls *.zip &>/dev/null; then
		for file in *.zip; do
			# Extract the base name without the .zip extension
			base_name="${file%.zip}"
			# Define the extraction directory
			extract_dir="$target_dir/$base_name"
			# Create the extraction directory if it doesn't exist
			mkdir -p "$extract_dir"
			# Unzip the file into the extraction directory
			unzip -q "$file" -d "$extract_dir"
			echo "Extracted '$file' into '$extract_dir'"
		done
	else
		echo "No ZIP files found in the current directory."
	fi
}

# Default to the current directory if no argument is provided
target_dir="${1:-.}"

# Check if the target directory exists; if not, create it
if [ ! -d "$target_dir" ]; then
	echo "Directory '$target_dir' does not exist. Creating it now."
	mkdir -p "$target_dir"
fi

# Call the function with the target directory
unzip_all "$target_dir"
