#!/bin/sh
### Script to create a GO-terms universe.
### We want to keep only the genes from our analysis (~12k instead of ~16k)
#Get the LOC IDs from the original GMTs (Dowloaded from g:profiler).
grep -o "LOC[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]" input/sinvicta.GO:CC.name.gmt | sort -u > tmp/GO_CC_uniq.txt
grep -o "LOC[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]" input/sinvicta.GO:BP.name.gmt | sort -u > tmp/GO_BP_uniq.txt
grep -o "LOC[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]" input/sinvicta.GO:MF.name.gmt | sort -u > tmp/GO_MF_uniq.txt

# Concatenate the results. This is a file with the LOC IDs present in the GMT dataset.
cat tmp/GO_MF_uniq.txt tmp/GO_CC_uniq.txt tmp/GO_BP_uniq.txt | sort -u > tmp/All_GO_uniq9k.txt


# Find our gene IDS present in the g:profiler GMT IDs.
grep -f input/2023_07_20_No_candidates.txt tmp/All_GO_uniq9k.txt > tmp/8k_no_candidates.txt

# Get the information from the original g:profiler GMTs.
grep -f tmp/8k_no_candidates.txt input/sinvicta.GO:BP.name.gmt > tmp/filtered_sinvicta.GO:BP.name.gmt
grep -f tmp/8k_no_candidates.txt input/sinvicta.GO:CC.name.gmt > tmp/filtered_sinvicta.GO:CC.name.gmt
grep -f tmp/8k_no_candidates.txt input/sinvicta.GO:MF.name.gmt > tmp/filtered_sinvicta.GO:MF.name.gmt
cat tmp/filtered_sinvicta.GO:* > tmp/filtered_sinvicta.GO_ALL.txt

# Use the bash script to delete the candidate genes from the file. 
./delete_candidates_from_GO.sh input/2023_07_06_Top1pc_genes.txt tmp/filtered_sinvicta.GO_ALL.txt tmp/july_20_no_candidates.txt

# Format the universe.
sed 's/\s/,/g' tmp/july_20_no_candidates.txt > tmp/filtered_sinvicta_GO_ALL.csv
sed 's/,//g' tmp/filtered_sinvicta_GO_ALL.txt > results/2023_07_Universe.gmt

