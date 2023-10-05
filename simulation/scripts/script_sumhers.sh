#!/bin/bash
#SBATCH --account dsmwpred
#SBATCH -c 4
#SBATCH --mem 4g

# Estimate per-predictor heritabilities assuming the GCTA Model.
mkdir results
mkdir results/tagging
mkdir results/snphers

./ldak --calc-tagging results/tagging/gcta \
    --bfile data/train/samples \
    --ignore-weights YES \
    --power -1 \
    --window-kb 1000 \
    --save-matrix YES

./ldak --sum-hers results/snphers/gcta \
    --tagfile results/tagging/gcta.tagging \
    --summary linreg/linreg.summaries \
    --matrix results/tagging/gcta.matrix