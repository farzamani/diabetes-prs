#!/bin/bash
#SBATCH --account dsmwpred
#SBATCH -c 8
#SBATCH --mem 256g
#SBATCH --time 12:00:00

# plink2 \
#     --bed data/target/geno2.bed \
#     --bim data/target/geno2.bim \
#     --fam data/target/geno2.fam \
#     --maf 0.01 \
#     --hwe 1e-6 \
#     --geno 0.01 \
#     --mind 0.01 \
#     --write-snplist \
#     --make-just-fam \
#     --out data/target/qc/geno2 \
#     --threads 8

# plink2 \
#     --bed data/target/geno2.bed \
#     --bim data/target/geno2.bim \
#     --fam data/target/geno2.fam \
#     --keep data/target/qc/geno2.fam \
#     --extract data/target/qc/geno2.snplist \
#     --indep-pairwise 100kb 0.8 \
#     --out data/target/qc/geno2.prune \
#     --threads 8

# plink2 \
#     --bed data/target/geno2.bed \
#     --bim data/target/geno2.bim \
#     --fam data/target/geno2.fam \
#     --keep data/target/qc/geno2.fam \
#     --extract data/target/qc/geno2.snplist \
#     --het \
#     --out data/target/qc/geno2.het \
#     --threads 8

# Rscript scripts/compute_het.R

plink2 \
    --bed data/target/geno2.bed \
    --bim data/target/geno2.bim \
    --fam data/target/geno2.fam \
    --keep data/target/qc/geno2.het.valid.fam \
    --extract data/target/qc/geno2.snplist \
    --king-cutoff 0.125 \
    --out data/target/qc/geno2.rel \
    --threads 8

# plink2 \
#     --bed data/target/geno2.bed \
#     --bim data/target/geno2.bim \
#     --fam data/target/geno2.fam \
#     --make-bed \
#     --keep {input.rel} \
#     --extract {input.snplist} \
#     --out {params.out}