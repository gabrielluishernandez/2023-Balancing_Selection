#!/bin/bash

# Loop from 1 to 100
for i in {1..100}; do
  # Create the new filename by replacing "Set1" with "Set${i}"
  new_filename=$(echo "get_the_candidates_Set1.R" | sed "s/Set1/Set${i}/")

  # Copy the original script to the new filename
  cp get_the_candidates_Set1.R "$new_filename"

  # Replace all occurrences of "set-1" with "set-${i}" in the new file
  sed -i "s/set-1/set-${i}/g" "$new_filename"
done

