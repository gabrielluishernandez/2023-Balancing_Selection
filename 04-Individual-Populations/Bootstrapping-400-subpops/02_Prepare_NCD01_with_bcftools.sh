#!/bin/bash
#$ -pe smp 20
#$ -l h_vmem=2G
#$ -l h_rt=40:0:0
#$ -cwd
#$ -j y
#$ -m beas

module load parallel
module load bcftools

for i in $(seq 1 100); do

	parallel -j 20 "bcftools query -f '%CHROM\t%POS\t%CHROM|%POS\t%REF\t%ALT\t%AF\n' set-${i}/{}.vcf.gz > set-${i}/{}_inputNCD.txt" :::: list_populations

done

