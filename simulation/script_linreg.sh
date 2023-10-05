#!/bin/bash
#SBATCH --account dsmwpred
#SBATCH -c 4
#SBATCH --mem 4g

mkdir linreg

./ldak --linear linreg/linreg \
    --bfile data/train/samples \
    --pheno data/samples.pheno \
