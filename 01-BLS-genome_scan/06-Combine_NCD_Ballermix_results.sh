#!/bin/bash

module load bedtools
module load parallel

# Create individual NCD files
parallel -j 8  "sed 's/|/\t/g' results/NCD1_win5Kb_step2500b.txt | grep {} > tmp/08-03-{}-NCD.txt " :::: chr_numbers

# Modify Ballermix files
awk '{print "CM031902.1",$1,$1+1,$3}' results/B0maf_ChrCM031901.1.txt > tmp/08-03-chr01-B0maf.txt
awk '{print "CM031902.1",$1,$1+1,$3}' results/B0maf_ChrCM031902.1.txt > tmp/08-03-chr02-B0maf.txt
awk '{print "CM031903.1",$1,$1+1,$3}' results/B0maf_ChrCM031903.1.txt > tmp/08-03-chr03-B0maf.txt
awk '{print "CM031904.1",$1,$1+1,$3}' results/B0maf_ChrCM031904.1.txt > tmp/08-03-chr04-B0maf.txt
awk '{print "CM031905.1",$1,$1+1,$3}' results/B0maf_ChrCM031905.1.txt > tmp/08-03-chr05-B0maf.txt
awk '{print "CM031906.1",$1,$1+1,$3}' results/B0maf_ChrCM031906.1.txt > tmp/08-03-chr06-B0maf.txt
awk '{print "CM031907.1",$1,$1+1,$3}' results/B0maf_ChrCM031907.1.txt > tmp/08-03-chr07-B0maf.txt
awk '{print "CM031908.1",$1,$1+1,$3}' results/B0maf_ChrCM031908.1.txt > tmp/08-03-chr08-B0maf.txt
awk '{print "CM031909.1",$1,$1+1,$3}' results/B0maf_ChrCM031909.1.txt > tmp/08-03-chr09-B0maf.txt
awk '{print "CM031910.1",$1,$1+1,$3}' results/B0maf_ChrCM031910.1.txt > tmp/08-03-chr10-B0maf.txt
awk '{print "CM031911.1",$1,$1+1,$3}' results/B0maf_ChrCM031911.1.txt > tmp/08-03-chr11-B0maf.txt
awk '{print "CM031912.1",$1,$1+1,$3}' results/B0maf_ChrCM031912.1.txt > tmp/08-03-chr12-B0maf.txt
awk '{print "CM031913.1",$1,$1+1,$3}' results/B0maf_ChrCM031913.1.txt > tmp/08-03-chr13-B0maf.txt
awk '{print "CM031914.1",$1,$1+1,$3}' results/B0maf_ChrCM031914.1.txt > tmp/08-03-chr14-B0maf.txt
awk '{print "CM031915.1",$1,$1+1,$3}' results/B0maf_ChrCM031915.1.txt > tmp/08-03-chr15-B0maf.txt

# Remove the first line (header)
parallel "sed -i '1d' tmp/08-03-chr{}-B0maf.txt" :::: short_chr_names

# Fix tabs
parallel -j 4 "sed 's/\s/\t/g' tmp/08-03-chr{}-B0maf.txt > tmp/08-03-chr{}-B0maf.bed" :::: short_chr_names

# Combine NCD and Ballermix
parallel -j 8 'bedtools intersect -wo -a tmp/08-03-CM0319{}.1-NCD.txt -b tmp/08-03-chr{}-B0maf.bed > results/08-03-Combined_Chr{}.txt' :::: short_chr_names

# Re-organise
awk '{print $9,$10,$11,$12,$2,$3,$6,$7,$8}' results/08-03-Combined_Chr01.txt | sed 's/\s/\t/g' > results/08-03-Combined_Chr01_ordered.txt
awk '{print $9,$10,$11,$12,$2,$3,$6,$7,$8}' results/08-03-Combined_Chr02.txt | sed 's/\s/\t/g' > results/08-03-Combined_Chr02_ordered.txt
awk '{print $9,$10,$11,$12,$2,$3,$6,$7,$8}' results/08-03-Combined_Chr03.txt | sed 's/\s/\t/g' > results/08-03-Combined_Chr03_ordered.txt
awk '{print $9,$10,$11,$12,$2,$3,$6,$7,$8}' results/08-03-Combined_Chr04.txt | sed 's/\s/\t/g' > results/08-03-Combined_Chr04_ordered.txt
awk '{print $9,$10,$11,$12,$2,$3,$6,$7,$8}' results/08-03-Combined_Chr05.txt | sed 's/\s/\t/g' > results/08-03-Combined_Chr05_ordered.txt
awk '{print $9,$10,$11,$12,$2,$3,$6,$7,$8}' results/08-03-Combined_Chr06.txt | sed 's/\s/\t/g' > results/08-03-Combined_Chr06_ordered.txt
awk '{print $9,$10,$11,$12,$2,$3,$6,$7,$8}' results/08-03-Combined_Chr07.txt | sed 's/\s/\t/g' > results/08-03-Combined_Chr07_ordered.txt
awk '{print $9,$10,$11,$12,$2,$3,$6,$7,$8}' results/08-03-Combined_Chr08.txt | sed 's/\s/\t/g' > results/08-03-Combined_Chr08_ordered.txt
awk '{print $9,$10,$11,$12,$2,$3,$6,$7,$8}' results/08-03-Combined_Chr09.txt | sed 's/\s/\t/g' > results/08-03-Combined_Chr09_ordered.txt
awk '{print $9,$10,$11,$12,$2,$3,$6,$7,$8}' results/08-03-Combined_Chr10.txt | sed 's/\s/\t/g' > results/08-03-Combined_Chr10_ordered.txt
awk '{print $9,$10,$11,$12,$2,$3,$6,$7,$8}' results/08-03-Combined_Chr11.txt | sed 's/\s/\t/g' > results/08-03-Combined_Chr11_ordered.txt
awk '{print $9,$10,$11,$12,$2,$3,$6,$7,$8}' results/08-03-Combined_Chr12.txt | sed 's/\s/\t/g' > results/08-03-Combined_Chr12_ordered.txt
awk '{print $9,$10,$11,$12,$2,$3,$6,$7,$8}' results/08-03-Combined_Chr13.txt | sed 's/\s/\t/g' > results/08-03-Combined_Chr13_ordered.txt
awk '{print $9,$10,$11,$12,$2,$3,$6,$7,$8}' results/08-03-Combined_Chr14.txt | sed 's/\s/\t/g' > results/08-03-Combined_Chr14_ordered.txt
awk '{print $9,$10,$11,$12,$2,$3,$6,$7,$8}' results/08-03-Combined_Chr15.txt | sed 's/\s/\t/g' > results/08-03-Combined_Chr15_ordered.txt

# Get gff and subset per chromosome
#cp /data/home/btx422/hive/flopezosorio/2021_popgen_invicta_richteri/results/01_map_annotations/2021-10-28-liftoff_ncbi_annotations/qmul_sinvicta_genomic.liftoff.tidy.longest_isoform.gff input/.

parallel 'bedtools intersect -wo -a input/qmul_sinvicta_genomic.liftoff.tidy.longest_isoform.gff -b results/08-03-Combined_Chr{}_ordered.txt > results/Chr{}.gff' :::: short_chr_names
cat results/*gff > results/08-03-All_Chr_anotation.gff

# Get the genes from gff
grep -Po "gene=\K.*?;" results/08-03-All_Chr_anotation.gff | sed 's/;//g' | uniq > tmp/list_unique_ids.txt
grep -f tmp/list_unique_ids.txt results/08-03-All_Chr_anotation.gff | awk '{print $(NF-9),$(NF-7),$(NF-6),$(NF-5),$(NF-4),$(NF-3),$(NF-2),$(NF-1)}' > tmp/out.txt
grep -Po "gene=\K.*?;" results/08-03-All_Chr_anotation.gff | sed 's/;//g' > tmp/list_ids.txt
paste tmp/list_ids.txt tmp/out.txt > results/Genes_Scored.txt
