# Software setup

git clone https://github.com/bioXiaoheng/BallerMixPlus.git

module load anaconda3
conda create --name python_for_ballermix
conda activate python_for_ballermix

cd BallerMixPlus
pip install -r requirements.txt
module load parallel

# Parse each chromosome
parallel -j 5 "python BallerMixPlus/parsing_scripts/parse_ballermix_input.py --vcf input/input.vcf.gz -c {} --rec_rate 1.25e-6 --hap -o tmp/parsed_{}.txt" :::: chr_numbers

# Concatenate for next step
cat tmp/parsed_*.txt | awk '(NR == 1 || $1 != "position")' > tmp/Concatenated_input_for_helper_file.txt

# Create helper file
python BallerMixPlus/BalLeRMix+_v1.py -i tmp/Concatenated_input_for_helper_file.txt --getSpect --noSub --MAF --spect tmp/SFS_MAF.txt

# Run Ballermix
parallel -j 16 'python BallerMixPlus/BalLeRMix+_v1.py --noSub --MAF --spect tmp/SFS_MAF.txt -i tmp/parsed_{}.txt -o results/B0maf_Chr{}.txt --findBal' :::: chr_numbers
