#!/usr/bin/env bash

# Author: Abdulrhman Ansary

# Move myCodes directory from or to (storage/projecrs) directory.

if [ -z "$1" ]; then
  echo "EmptyOperandError: Type '-t' to take or '-g' to give myCodes directory"
elif [ "$1" = "--take" ] || [ "$1" = "-t" ]; then
  mv ~/storage/shared/myCodes ~/projects
  echo "myCodes directory moved to ~/projects."
elif [ "$1" = "--give" ] || [ "$1" = "-g" ]; then
  mv ~/projects/myCodes ~/storage/shared
  echo "myCodes directory moved to ~/storage/shared."
else
  echo "InvalidInputError: '$1' is an invalid argument. Use '-t' or '-g'."
fi
