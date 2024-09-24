#!/usr/bin/env bash
# Author: Abdulrhman Ansary

# Verify that the user has entered the text to be replaced
if [ -z "$1" ]; then
  echo "UsageError: Please provide the text to replace as the first argument."
  exit 1
fi

# Verify that the user has entered the new text
if [ -z "$2" ]; then
  echo "UsageError: Please provide the new text as the second argument."
  exit 1
fi

text=$1
alteText=$2
fileName=$3

# Check for special characters in the text and the replacement text
if [[ "$text" =~ [/\&\|] || "$alteText" =~ [/\&\|] ]]; then
  echo "SpecialCharacterError: The text contains special characters (e.g., '/', '&', '|')."
  echo "Solution: Use escape sequences (e.g., '\/') for special characters."
  echo "Applying auto-escape for you..."

  # Automatically escape the special characters
  text=$(echo "$text" | sed 's/\//\\\//g')
  alteText=$(echo "$alteText" | sed 's/\//\\\//g')
fi

# Initialize counters
filesCount=0
filesWithText=0

# Function to replace text from a file
replace_text_from_file() {
  local file=$1
  # Check if the file contains the text
  if grep -q "$text" "$file"; then
    # replace the text from the file
    sed -i "s/$text/$alteText/g" "$file"
    echo "'$text' has been replaced by '$alteText' in the file '$file'."
    return 0
  else
    return 1
  fi
}

# If a specific file is selected
if [ -n "$fileName" ]; then
  # Verify that the file exists
  if [ -f "$fileName" ]; then
    # Try to replace the text from the selected file
    ((filesCount++)) # Increment files count
    if ! replace_text_from_file "$fileName"; then
      echo "TextError: '$text' not found in '$fileName'."
      exit 1
    else
      ((filesWithText++)) # Increment files with text count
    fi
  else
    echo "FileError: File '$fileName' not found."
    exit 1
  fi
else
  # If a file is not selected, search all files in the current directory
  for file in *; do
    if [ -f "$file" ]; then
      # If the text is found in the file, replace it
      if replace_text_from_file "$file"; then
        ((filesWithText++))
      fi
      ((filesCount++))
    fi
  done

  # Check if any file contained the text
  if [ "$filesWithText" -eq 0 ]; then
    echo "TextError: '$text' not found in any file."
    exit 1
  fi
fi

# Output the final result
echo "Process completed: '$text' was replaced by '$alteText' in $filesWithText files out of $filesCount files."
