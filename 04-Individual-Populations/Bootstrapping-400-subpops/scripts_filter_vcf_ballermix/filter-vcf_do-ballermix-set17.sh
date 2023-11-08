#!/brain/bash
#$ -pe smp 20
#$ -l h_vmem=2G
#$ -l h_rt=40:0:0
#$ -cwd
#$ -j y
#$ -m beas


module load anaconda3
conda activate python_for_ballermix
module load parallel
module load vcftools
module load samtools
module load bcftools


# VCF filtering for each of the 4 populations in set-17
echo "Performing VCF filtering..."

parallel -j 19 'vcftools --gzvcf input/2022-05-18-missingness_10_samples_240_haploid.vcf.gz \
--keep set-17/{} \
--recode --stdout \
| bcftools filter --include "N_MISSING <= 10" \
| bcftools +fixploidy -- --force-ploidy 1 \
| bcftools view --min-ac 1:minor \
| bcftools +fill-tags -- -t AF,AC,F_MISSING \
| bgzip -c > set-17/{}.vcf.gz' ::: pop1 pop2 pop3 pop4

echo "VCF filtering done."

# Running BallerMixPlus script for each population and each chromosome
echo "Running BallerMixPlus parsing script..."

for pop in "pop1" "pop2" "pop3" "pop4"; do
  pop_file="set-17/${pop}.vcf.gz"

  # Check if the population VCF file exists
  if [ ! -f $pop_file ]; then
    echo "File $pop_file does not exist, skipping..."
    continue
  fi

  parallel -j 10 "python BallerMixPlus/parsing_scripts/parse_ballermix_input.py --vcf set-17/${pop}.vcf.gz -c {} --rec_rate 1.25e-6 --hap -o set-17/2023-08-02-${pop}_{}.txt" :::: chr_numbers

if [ $? -ne 0 ]; then
    echo "Error in parallel command for parsing. Exiting."
    exit 1
  fi

  cat set-17/2023-08-02-${pop}* | awk '(NR == 1 || $1 != "position")' > set-17/2023-Concatenated_${pop}_input_for_helper_file.txt

  python BallerMixPlus/BalLeRMix+_v1.py -i set-17/2023-Concatenated_${pop}_input_for_helper_file.txt --getSpect --noSub --MAF --spect set-17/2023-${pop}SFS_MAF.txt

  parallel -j 19 "python BallerMixPlus/BalLeRMix+_v1.py --noSub --MAF --spect set-17/2023-${pop}SFS_MAF.txt -i set-17/2023-08-02-${pop}_{}.txt -o set-17/B0maf_${pop}_Chr{}.txt --findBal" :::: chr_numbers

done

echo "All tasks complete."

