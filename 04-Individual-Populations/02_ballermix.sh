#!/bin/bash
#git clone https://github.com/bioXiaoheng/BallerMixPlus.git

module load anaconda3
conda activate python_for_ballermix
module load parallel

# Parse each chromosome
parallel -j 6 "python BallerMixPlus/parsing_scripts/parse_ballermix_input.py --vcf tmp/2023-08-02-Pop3_only.vcf.gz -c {} --rec_rate 1.25e-6 --hap -o tmp/2023-08-02-Pop3_{}.txt" :::: chr_numbers

# Concatenate for next step
cat tmp/2023-08-02-Pop3_*.txt | awk '(NR == 1 || $1 != "position")' > tmp/2023-08-02-Concatenated_Pop3_input_for_helper_file.txt

# Create helper file
python BallerMixPlus/BalLeRMix+_v1.py -i tmp/2023-08-02-Concatenated_Pop3_input_for_helper_file.txt --getSpect --noSub --MAF --spect tmp/2023-08-02-SFS_MAF.txt

# Run Ballermix (~3 hours)
parallel -j 16 'python BallerMixPlus/BalLeRMix+_v1.py --noSub --MAF --spect tmp/2023-08-02-SFS_MAF.txt -i tmp/2023-08-02-Pop3_{}.txt -o results/08-02-B0maf_Chr{}.txt --findBal' :::: chr_numbers
