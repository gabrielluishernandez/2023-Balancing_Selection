#!/bin/bash

module load vcftools
module load samtools
module load bcftools

vcftools --gzvcf input/2022-05-18-missingness_10_samples_240_haploid.vcf.gz \
--keep input/2023_08_02_Pop3_sample_name.txt \
--recode --stdout \
| bcftools filter --include "N_MISSING <= 10" \
| bcftools +fixploidy -- --force-ploidy 1 \
| bcftools view --min-ac 1:minor \
| bcftools +fill-tags -- -t AF,AC,F_MISSING \
| bgzip -c > tmp/2023-08-02-Pop3_only.vcf.gz
