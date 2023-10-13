#!/bin/bash
#SBATCH --account farzamani
#SBATCH -c 6
#SBATCH --mem 16g

mkdir data/bed

chrom=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10" \ 
        "11" "12" "13" "14" "15" "16" "17" "18" \
        "19" "20" "21" "22" "X" "XY")

for chr in "${chrom[@]}"; do

plink2 --make-bed --out data/bed/chr$chr \
    --pgen data/geno_plink/chr$chr.pgen \
    --pvar data/geno_plink/chr$chr.pvar \
    --psam data/geno_plink/chr$chr.psam

done