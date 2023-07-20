#!/bin/sh

#Get the LOC IDs from the original GMTs.
grep -o "LOC[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]" input/sinvicta.GO:CC.name.gmt | sort -u > tmp/GO_CC_uniq.txt
grep -o "LOC[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]" input/sinvicta.GO:BP.name.gmt | sort -u > tmp/GO_BP_uniq.txt
grep -o "LOC[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]" input/sinvicta.GO:MF.name.gmt | sort -u > tmp/GO_MF_uniq.txt

# Concatenate the results.
# This is a file with the LOC IDs present in the GMT dataset from g:profiler for S. invicta.

cat tmp/GO_MF_uniq.txt tmp/GO_CC_uniq.txt tmp/GO_BP_uniq.txt | sort -u > tmp/All_GO_uniq9k.txt

# Combine the gene list with files from our Rstudio.
cat input/2023_04_17_No_candidates.txt input/2023_04_17_Top100_genes.txt > input/all_our_genes.txt

# Find our gene IDS present in the g:profiler GMT IDs.
grep -f input/all_our_genes.txt tmp/All_GO_uniq9k.txt > tmp/8k_no_candidates.txt

# Get the information from the original g:profiler GMTs.
# This is to have our own universe
grep -f tmp/8k_no_candidates.txt input/sinvicta.GO:BP.name.gmt > tmp/filtered_sinvicta.GO:BP.name.gmt
grep -f tmp/8k_no_candidates.txt input/sinvicta.GO:CC.name.gmt > tmp/filtered_sinvicta.GO:CC.name.gmt
grep -f tmp/8k_no_candidates.txt input/sinvicta.GO:MF.name.gmt > tmp/filtered_sinvicta.GO:MF.name.gmt

# Combine ant format to finally have a universe.
cat tmp/filtered_sinvicta.GO:* > tmp/filtered_sinvicta.GO_ALL.txt
sed 's/\s/,/g' tmp/filtered_sinvicta_GO_ALL.txt > tmp/filtered_sinvicta_GO_ALL.csv
sed 's/,//g' tmp/filtered_sinvicta_GO_ALL.txt > results/2023_05_Universe.txt


###
9203  grep -f input/2023-06-19-Master_GENES.txt tmp/All_GO_uniq9k.txt > tmp/july_8k_no_candidates.txt
 9204  grep -f tmp/july_8k_no_candidates.txt input/sinvicta.GO:BP.name.gmt > tmp/filtered_sinvicta.GO:BP.name.gmt
 9205  grep -f tmp/july_8k_no_candidates.txt input/sinvicta.GO:CC.name.gmt > tmp/filtered_sinvicta.GO:CC.name.gmt
 9206  grep -f tmp/july_8k_no_candidates.txt input/sinvicta.GO:MF.name.gmt > tmp/filtered_sinvicta.GO:MF.name.gmt
 9207  cat tmp/filtered_sinvicta.GO:* > tmp/filtered_sinvicta.GO_ALL.txt
 9208  sed 's/\s/,/g' tmp/filtered_sinvicta_GO_ALL.txt > tmp/filtered_sinvicta_GO_ALL.csv
 9209  sed 's/,//g' tmp/filtered_sinvicta_GO_ALL.txt > results/2023_07_Universe.txt
 9210  head results/2023_05_Universe.gmt
 9211  head results/2023_07_Universe.txt
 9212  mv results/2023_07_Universe.txt results/2023_07_Universe.gmt

