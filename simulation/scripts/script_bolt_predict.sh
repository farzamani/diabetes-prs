#!/bin/bash
#SBATCH --account dsmwpred
#SBATCH -c 4
#SBATCH --mem 4g

# Bolt predict
mkdir results/bolt

./ldak --bolt results/bolt/bolt \
    --pheno data/samples.pheno \
    --bfile data/train/samples \
    --ind-hers results/snphers/gcta.ind.hers \
    --cv-proportion .1

./ldak --calc-scores results/bolt/score \
    --scorefile results/bolt/bolt.effects \
    --bfile data/validation/samples \
    --pheno data/samples.pheno \
    --power 0