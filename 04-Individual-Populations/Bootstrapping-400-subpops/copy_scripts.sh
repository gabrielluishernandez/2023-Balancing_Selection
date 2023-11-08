#!/bin/bash

# Loop to create 100 new scripts.
for i in $(seq 1 100); do
    # Copy the original script to a new file.
    cp filter-vcf_and_do-ballermix.sh "filter-vcf_do-ballermix-set${i}.sh"

    # Use sed to replace 'set-1' with 'set-${i}' in the new file.
    sed -i "s/set-1/set-${i}/g" "filter-vcf_do-ballermix-set${i}.sh"
done

