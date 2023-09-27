mp 1
#$ -l h_vmem=20G
#$ -l h_rt=240:0:0
#$ -cwd
#$ -j y

module load vcftools
module load samtools

vcftools --gzvcf input/2022-02-16-solenopsis_all_369samples.norm.maskfilter.biallelicsnps.DP1.GQ20.vcf.gz \
 --keep input/s_invicta_samples_roddy \
 --recode --stdout \
 | bgzip -c > tmp/2022-03-15-Only_241_Inv.vcf.gz
