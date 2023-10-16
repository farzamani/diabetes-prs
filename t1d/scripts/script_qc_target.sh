#!/bin/bash
#SBATCH --account farzamani
#SBATCH -c 6
#SBATCH --mem 4g

mkdir data/target

plink2 \
    --pfile data/geno_plink/chr6 \
    --rm-dup list \
    --write-snplist \
    --out data/target/chr6

plink2 \
    --pfile data/geno_plink/chr6 \
    --maf 0.01 \
    --hwe 1e-6 \
    --geno 0.01 \
    --mind 0.01 \
    --write-snplist \
    --make-just-fam \
    --exclude data/target/chr6.rmdup.mismatch \
    --out data/target/chr6

plink2 \
    --pfile data/geno_plink/chr6 \
    --keep data/target/chr6.fam \
    --extract data/target/chr6.snplist \
    --indep-pairwise 200 50 0.25 \
    --out data/target/chr6

plink2 \
    --pfile data/geno_plink/chr6 \
    --extract data/target/chr6.prune.in \
    --keep data/target/chr6.fam \
    --het \
    --out data/target/chr6

plink2 \
    --pfile data/geno_plink/chr6 \
    --extract data/target/chr6.prune.in \
    --check-sex \
    --out data/target/chr6

plink2 \
    --pfile data/geno_plink/chr6 \
    --extract data/target/chr6.prune.in \
    --rel-cutoff 0.125 \
    --out data/target/chr6

plink2 \
    --pfile data/geno_plink/chr6 \
    --make-bed \
    --keep EUR.QC.rel.id \
    --out EUR.QC \
    --extract EUR.QC.snplist \
    --exclude EUR.mismatch \
    --a1-allele EUR.a1