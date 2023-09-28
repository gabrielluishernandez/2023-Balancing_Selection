
# Adding 1kb in each direction was done for the peaks in R
# 2023-03-27-General_summary_BS195/candidates_selection.Rmd

bedtools intersect -wo -a input/qmul_sinvicta_genomic.liftoff.tidy.longest_isoform.gff \
 -b input/2023_05_31_Top_peaks.txt > tmp/Peaks_1kb.gff

grep -Po "gene=\K.*?;" tmp/Peaks_1kb.gff | sed 's/;//g' | uniq > tmp/list_unique_ids.txt
grep -f tmp/list_unique_ids.txt tmp/Peaks_1kb.gff | awk '{print $(NF-5),$(NF-4),$(NF-3),$(NF-2),$(NF-1)}' > tmp/out.txt
grep -Po "gene=\K.*?;" tmp/Peaks_1kb.gff | sed 's/;//g' > tmp/list_ids.txt
paste tmp/list_ids.txt tmp/out.txt > tmp/Peak_genes_Scored.txt

cut -f 1 tmp/Peak_genes_Scored.txt | sort -u > tmp/88_genes.txt 
cut -f 4 input/2023_05_31_Top_peaks.txt | sort -u > tmp/genes83_original_peaks.txt
grep -vf tmp/genes83_original_peaks.txt tmp/88_genes.txt > results/2023_05_31_additional_genes_from_1kb.txt
cat tmp/genes83_original_peaks.txt results/2023_05_31_additional_genes_from_1kb.txt > results/2023_05_31_Final_candidates.txt
grep -f results/2023_05_31_additional_genes_from_1kb.txt tmp/Peak_genes_Scored.txt | sed '/^$/d' | awk '!a[$1]++' | awk '{print $1,$5}' > results/2023_05_31_Table_of_old_and_new_genes.txt

# I just need to add a row to the main  table with this 4 new genes. 
# The values for the summary statistics are the same as the other gene in that peak.
