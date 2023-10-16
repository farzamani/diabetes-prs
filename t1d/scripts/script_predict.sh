#!/bin/bash
#SBATCH --account dsmwpred
#SBATCH -c 6
#SBATCH --mem 64g

models=("lasso" "ridge" "bolt" "bayesr")

for model in "${models[@]}"; do

    ./ldak --calc-scores results/megaprs/$model/score \
        --scorefile results/megaprs/$model/$model.effects \
        --bfile data/bed/chr6 \
        --pheno data/t1d.pheno \
        --power 0

done