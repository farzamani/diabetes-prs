#!/bin/bash
#SBATCH --account dsmwpred
#SBATCH -c 6
#SBATCH --mem 4g

models=("lasso" "ridge" "bolt" "bayesr")

for model in "${models[@]}"; do

    ./ldak --calc-scores results/megaprs/$model/score \
        --scorefile results/megaprs/$model/$model.effects \
        --bfile data/validation/samples \
        --pheno data/samples.pheno \
        --power 0

done

