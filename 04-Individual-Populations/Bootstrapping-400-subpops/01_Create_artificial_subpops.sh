#!/bin/bash

# Loop to create 100 sets
for i in $(seq 1 100); do
  # Create directory for each set
  dir_name="set-$i"
  mkdir -p $dir_name
  
  # Initialize counters
  count=0

  # Randomize the list of names for each set
  shuf "input/All_4pops_samples.txt" > shuffled_names.txt

  # Read each line from the shuffled input file
  while IFS= read -r line; do
    count=$((count + 1))

    # Define output file based on current name count
    if [ $count -le 22 ]; then
      outfile="${dir_name}/pop1"
    elif [ $count -le $((22 + 40)) ]; then
      outfile="${dir_name}/pop2"
    elif [ $count -le $((22 + 40 + 48)) ]; then
      outfile="${dir_name}/pop3"
    elif [ $count -le $((22 + 40 + 48 + 23)) ]; then
      outfile="${dir_name}/pop4"
    fi
    
    # Append name to the appropriate output file
    echo "$line" >> $outfile
  done < "shuffled_names.txt"

  # Remove the shuffled names file
  rm shuffled_names.txt
done

echo "Done! Created 100 sets."

