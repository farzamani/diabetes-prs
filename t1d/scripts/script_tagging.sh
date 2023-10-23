#!/bin/bash
#SBATCH --account dsmwpred
#SBATCH -c 6
#SBATCH --mem 16g

# Estimate per-predictor heritabilities assuming the GCTA Model.
mkdir results
mkdir results/tagging

./ldak --calc-tagging results/tagging/1000G.404EUR \
    --bfile data/reference/1000G.404EUR \
    --ignore-weights YES \
    --power -1 \
    --window-kb 1000 \
    --save-matrix YES