#!/bin/bash

# Loop through each folder in /local/*
for dir in /local/*; do
  # Check if it's a directory
  if [ -d "$dir" ]; then
    # Test if we have read access to the directory
    if [ -r "$dir" ]; then
      echo "$dir"
      exit 0
    fi
  fi
done

echo "No directory accessible" >&2
echo ""
exit 0