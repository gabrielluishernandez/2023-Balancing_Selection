#!/bin/bash
#$ -pe smp 15
#$ -l h_vmem=2G
#$ -l h_rt=20:0:0
#$ -cwd
#$ -j y
#$ -m beas

module load bedtools
module load parallel


for i in {1..4}; do


 sed 's/|/\t/g' set-31/pop${i}-NCD1_win5Kb_step2500b.txt | grep "CM031901.1" > set-31/pop${i}-chr1-NCD.txt
 sed 's/|/\t/g' set-31/pop${i}-NCD1_win5Kb_step2500b.txt | grep "CM031902.1" > set-31/pop${i}-chr2-NCD.txt
 sed 's/|/\t/g' set-31/pop${i}-NCD1_win5Kb_step2500b.txt | grep "CM031903.1" > set-31/pop${i}-chr3-NCD.txt
 sed 's/|/\t/g' set-31/pop${i}-NCD1_win5Kb_step2500b.txt | grep "CM031904.1" > set-31/pop${i}-chr4-NCD.txt
 sed 's/|/\t/g' set-31/pop${i}-NCD1_win5Kb_step2500b.txt | grep "CM031905.1" > set-31/pop${i}-chr5-NCD.txt
 sed 's/|/\t/g' set-31/pop${i}-NCD1_win5Kb_step2500b.txt | grep "CM031906.1" > set-31/pop${i}-chr6-NCD.txt
 sed 's/|/\t/g' set-31/pop${i}-NCD1_win5Kb_step2500b.txt | grep "CM031907.1" > set-31/pop${i}-chr7-NCD.txt
 sed 's/|/\t/g' set-31/pop${i}-NCD1_win5Kb_step2500b.txt | grep "CM031908.1" > set-31/pop${i}-chr8-NCD.txt
 sed 's/|/\t/g' set-31/pop${i}-NCD1_win5Kb_step2500b.txt | grep "CM031909.1" > set-31/pop${i}-chr9-NCD.txt
 sed 's/|/\t/g' set-31/pop${i}-NCD1_win5Kb_step2500b.txt | grep "CM031910.1" > set-31/pop${i}-chr10-NCD.txt
 sed 's/|/\t/g' set-31/pop${i}-NCD1_win5Kb_step2500b.txt | grep "CM031911.1" > set-31/pop${i}-chr11-NCD.txt
 sed 's/|/\t/g' set-31/pop${i}-NCD1_win5Kb_step2500b.txt | grep "CM031912.1" > set-31/pop${i}-chr12-NCD.txt
 sed 's/|/\t/g' set-31/pop${i}-NCD1_win5Kb_step2500b.txt | grep "CM031913.1" > set-31/pop${i}-chr13-NCD.txt
 sed 's/|/\t/g' set-31/pop${i}-NCD1_win5Kb_step2500b.txt | grep "CM031914.1" > set-31/pop${i}-chr14-NCD.txt
 sed 's/|/\t/g' set-31/pop${i}-NCD1_win5Kb_step2500b.txt | grep "CM031915.1" > set-31/pop${i}-chr15-NCD.txt

 
 # Modify Ballermix files
 awk '{print "CM031901.1",$1,$1+1,$3}' set-31/B0maf_pop${i}_ChrCM031901.1.txt > set-31/pop${i}-chr1-B0maf.txt
 awk '{print "CM031902.1",$1,$1+1,$3}' set-31/B0maf_pop${i}_ChrCM031902.1.txt > set-31/pop${i}-chr2-B0maf.txt
 awk '{print "CM031903.1",$1,$1+1,$3}' set-31/B0maf_pop${i}_ChrCM031903.1.txt > set-31/pop${i}-chr3-B0maf.txt
 awk '{print "CM031904.1",$1,$1+1,$3}' set-31/B0maf_pop${i}_ChrCM031904.1.txt > set-31/pop${i}-chr4-B0maf.txt
 awk '{print "CM031905.1",$1,$1+1,$3}' set-31/B0maf_pop${i}_ChrCM031905.1.txt > set-31/pop${i}-chr5-B0maf.txt
 awk '{print "CM031906.1",$1,$1+1,$3}' set-31/B0maf_pop${i}_ChrCM031906.1.txt > set-31/pop${i}-chr6-B0maf.txt
 awk '{print "CM031907.1",$1,$1+1,$3}' set-31/B0maf_pop${i}_ChrCM031907.1.txt > set-31/pop${i}-chr7-B0maf.txt
 awk '{print "CM031908.1",$1,$1+1,$3}' set-31/B0maf_pop${i}_ChrCM031908.1.txt > set-31/pop${i}-chr8-B0maf.txt
 awk '{print "CM031909.1",$1,$1+1,$3}' set-31/B0maf_pop${i}_ChrCM031909.1.txt > set-31/pop${i}-chr9-B0maf.txt
 awk '{print "CM031910.1",$1,$1+1,$3}' set-31/B0maf_pop${i}_ChrCM031910.1.txt > set-31/pop${i}-chr10-B0maf.txt
 awk '{print "CM031911.1",$1,$1+1,$3}' set-31/B0maf_pop${i}_ChrCM031911.1.txt > set-31/pop${i}-chr11-B0maf.txt
 awk '{print "CM031912.1",$1,$1+1,$3}' set-31/B0maf_pop${i}_ChrCM031912.1.txt > set-31/pop${i}-chr12-B0maf.txt
 awk '{print "CM031913.1",$1,$1+1,$3}' set-31/B0maf_pop${i}_ChrCM031913.1.txt > set-31/pop${i}-chr13-B0maf.txt
 awk '{print "CM031914.1",$1,$1+1,$3}' set-31/B0maf_pop${i}_ChrCM031914.1.txt > set-31/pop${i}-chr14-B0maf.txt
 awk '{print "CM031915.1",$1,$1+1,$3}' set-31/B0maf_pop${i}_ChrCM031915.1.txt > set-31/pop${i}-chr15-B0maf.txt


 # Remove the first line (header)
 parallel -j 15 "sed -i '1d' set-31/pop${i}-{}-B0maf.txt" :::: short_chr_names

 # Fix tabs
 parallel -j 15 "sed 's/\s/\t/g' set-31/pop${i}-{}-B0maf.txt > set-31/pop${i}-{}-B0maf.bed" :::: short_chr_names

 # Combine NCD and Ballermix
 parallel -j 15 "bedtools intersect -wo -a set-31/pop${i}-{}-NCD.txt -b set-31/pop${i}-{}-B0maf.bed > set-31/pop${i}-Combined_{}.txt" :::: short_chr_names

 # Re-organise
 awk '{print $9,$10,$11,$12,$2,$3,$6,$7,$8}' set-31/pop${i}-Combined_chr1.txt | sed 's/\s/\t/g' > set-31/pop${i}-Combined_chr1_ordered.txt
 awk '{print $9,$10,$11,$12,$2,$3,$6,$7,$8}' set-31/pop${i}-Combined_chr2.txt | sed 's/\s/\t/g' > set-31/pop${i}-Combined_chr2_ordered.txt
 awk '{print $9,$10,$11,$12,$2,$3,$6,$7,$8}' set-31/pop${i}-Combined_chr3.txt | sed 's/\s/\t/g' > set-31/pop${i}-Combined_chr3_ordered.txt
 awk '{print $9,$10,$11,$12,$2,$3,$6,$7,$8}' set-31/pop${i}-Combined_chr4.txt | sed 's/\s/\t/g' > set-31/pop${i}-Combined_chr4_ordered.txt
 awk '{print $9,$10,$11,$12,$2,$3,$6,$7,$8}' set-31/pop${i}-Combined_chr5.txt | sed 's/\s/\t/g' > set-31/pop${i}-Combined_chr5_ordered.txt
 awk '{print $9,$10,$11,$12,$2,$3,$6,$7,$8}' set-31/pop${i}-Combined_chr6.txt | sed 's/\s/\t/g' > set-31/pop${i}-Combined_chr6_ordered.txt
 awk '{print $9,$10,$11,$12,$2,$3,$6,$7,$8}' set-31/pop${i}-Combined_chr7.txt | sed 's/\s/\t/g' > set-31/pop${i}-Combined_chr7_ordered.txt
 awk '{print $9,$10,$11,$12,$2,$3,$6,$7,$8}' set-31/pop${i}-Combined_chr8.txt | sed 's/\s/\t/g' > set-31/pop${i}-Combined_chr8_ordered.txt
 awk '{print $9,$10,$11,$12,$2,$3,$6,$7,$8}' set-31/pop${i}-Combined_chr9.txt | sed 's/\s/\t/g' > set-31/pop${i}-Combined_chr9_ordered.txt
 awk '{print $9,$10,$11,$12,$2,$3,$6,$7,$8}' set-31/pop${i}-Combined_chr10.txt | sed 's/\s/\t/g' > set-31/pop${i}-Combined_chr10_ordered.txt
 awk '{print $9,$10,$11,$12,$2,$3,$6,$7,$8}' set-31/pop${i}-Combined_chr11.txt | sed 's/\s/\t/g' > set-31/pop${i}-Combined_chr11_ordered.txt
 awk '{print $9,$10,$11,$12,$2,$3,$6,$7,$8}' set-31/pop${i}-Combined_chr12.txt | sed 's/\s/\t/g' > set-31/pop${i}-Combined_chr12_ordered.txt
 awk '{print $9,$10,$11,$12,$2,$3,$6,$7,$8}' set-31/pop${i}-Combined_chr13.txt | sed 's/\s/\t/g' > set-31/pop${i}-Combined_chr13_ordered.txt
 awk '{print $9,$10,$11,$12,$2,$3,$6,$7,$8}' set-31/pop${i}-Combined_chr14.txt | sed 's/\s/\t/g' > set-31/pop${i}-Combined_chr14_ordered.txt
 awk '{print $9,$10,$11,$12,$2,$3,$6,$7,$8}' set-31/pop${i}-Combined_chr15.txt | sed 's/\s/\t/g' > set-31/pop${i}-Combined_chr15_ordered.txt


 # Get gff and subset per chromosome
 #cp /data/home/btx422/hive/flopezosorio/2021_popgen_invicta_richteri/results/01_map_annotations/2021-10-28-liftoff_ncbi_annotations/qmul_sinvicta_genomic.liftoff.tidy.longest_isoform.gff input/.

 parallel -j 15 "bedtools intersect -wo -a input/qmul_sinvicta_genomic.liftoff.tidy.longest_isoform.gff -b set-31/pop${i}-Combined_{}_ordered.txt > set-31/pop${i}_{}.anotation" :::: short_chr_names

 cat set-31/pop${i}_*.anotation > set-31/pop${i}-All_Chr_anotation.gff

 # Get the genes from gff
 grep -Po "gene=\K.*?;" set-31/pop${i}-All_Chr_anotation.gff | sed 's/;//g' | uniq > set-31/pop${i}-list_unique_ids.txt
 grep -f set-31/pop${i}-list_unique_ids.txt set-31/pop${i}-All_Chr_anotation.gff | awk '{print $(NF-9),$(NF-7),$(NF-6),$(NF-5),$(NF-4),$(NF-3),$(NF-2),$(NF-1)}' > set-31/pop${i}-out.txt
 grep -Po "gene=\K.*?;" set-31/pop${i}-All_Chr_anotation.gff | sed 's/;//g' > set-31/pop${i}-list_ids.txt
 paste set-31/pop${i}-list_ids.txt set-31/pop${i}-out.txt > set-31/set-31-pop${i}-Final_Genes_Scored.txt


done
