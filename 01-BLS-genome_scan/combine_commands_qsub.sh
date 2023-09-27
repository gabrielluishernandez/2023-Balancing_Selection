#!/bin/bash
#$ -pe smp 1
#$ -l h_vmem=20G
#$ -l h_rt=40:0:0
#$ -cwd
#$ -j y

module load vcftools
module load samtools
module load bcftools

vcftools --gzvcf input/2022-02-16-solenopsis_all_369samples.norm.maskfilter.biallelicsnps.DP1.GQ20.vcf.gz \
--keep samples_to_keep \
--recode --stdout \
| bcftools filter --include "N_MISSING <= 10" \
| bcftools +fixploidy -- --force-ploidy 1 \
| bcftools view --min-ac 1:minor \
| bcftools +fill-tags -- -t AF,AC,F_MISSING \
| bgzip -c > results/2022-05-18-missingness_10_samples_240_haploid.vcf.gz


