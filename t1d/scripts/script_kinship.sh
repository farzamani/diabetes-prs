#!/bin/bash
#SBATCH --account dsmwpred
#SBATCH -c 4
#SBATCH --mem 4g

./ldak --thin data/target/qc/chr6 \
    --bfile data/geno_plink/chr6 \
    --window-prune .05 \
    --window-kb 1000 \
    --extract data/sumstats/rsids.list

./ldak --calc-kins-direct data/target/qc/chr6 \
    --bfile data/geno_plink/chr6 \
    --ignore-weights YES \
    --power -1 \
    --extract data/sumstats/rsids.list

./ldak.out --pca data/target/qc/chr6 \
    --grm data/target/qc/chr6 \
    --axes 20

./ldak.out --calc-pca-loads data/target/qc/chr6 \
    --pcastem data/target/qc/chr6 \
    --grm data/target/qc/chr6 \
    --bfile data/geno_plink/chr6

./ldak.out --calc-scores hapmap \
    --scorefile hapmap.load \
    --bfile human \
    --power 0