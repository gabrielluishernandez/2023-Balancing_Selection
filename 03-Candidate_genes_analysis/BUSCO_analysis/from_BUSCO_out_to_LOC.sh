#!/bin/bash

#grep "Complete" 02_busco_lepidoptera_tmp/run_lepidoptera_odb10/full_table.tsv | cut -f 3 | sort -u > tmp_protein/XM-ids.txt

grep -f blast_tmp/out_XM_inv.txt qmul_sinvicta_genomic.liftoff.tidy.longest_isoform.gff > tmp_protein/filtered.gff

grep -Po "gene=\K.*?;" tmp_protein/filtered.gff | sed 's/;//g' | uniq > tmp_protein/list_uniq_ids.txt
grep -f tmp_protein/list_uniq_ids.txt tmp_protein/filtered.gff | awk '{print $(NF-4),$(NF-3),$(NF-2),$(NF-1),$NF}' > tmp_protein/out.txt
grep -Po "gene=\K.*?;" tmp_protein/filtered.gff | sed 's/;//g' > tmp_protein/list_ids.txt
paste tmp_protein/list_ids.txt tmp_protein/out.txt > tmp_protein/combine.txt

cut -f 1 tmp_protein/combine.txt | sort -u > results/proteins_Osmia_LOC.txt

