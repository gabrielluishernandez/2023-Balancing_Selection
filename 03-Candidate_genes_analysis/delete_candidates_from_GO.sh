#!/bin/bash

# Check if all three filenames are provided as arguments
if [ $# -ne 3 ]; then
    echo "Usage: $0 <fileA> <fileB> <output_file>"
    exit 1
fi

fileA="$1"
fileB="$2"
output_file="$3"

# Check if both files exist
if [ ! -f "$fileA" ]; then
    echo "Error: $fileA does not exist."
    exit 1
fi

if [ ! -f "$fileB" ]; then
    echo "Error: $fileB does not exist."
    exit 1
fi

# Use sed to remove words from fileB based on patterns from fileA
sed -E "s/\\b($(paste -sd'|' "$fileA"))\\b//g" "$fileB" > "$output_file"

echo "Words from $fileA removed from $fileB and saved in $output_file successfully."

