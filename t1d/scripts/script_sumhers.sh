#!/bin/bash
#SBATCH --account farzamani
#SBATCH -c 6
#SBATCH --mem 16g

# Estimate per-predictor heritabilities assuming the GCTA Model.
mkdir results
mkdir results/snphers

./ldak --sum-hers results/snphers/sumher \
    --tagfile results/tagging/1000G.404EUR.tagging \
    --summary data/sumstats/sumstats.txt \
    --matrix results/tagging/1000G.404EUR.matrix \
    --extract data/sumstats/snps.list \
    --max-threads 6