#!/bin/bash
#SBATCH --account dsmwpred
#SBATCH -c 6
#SBATCH --mem 64g

mkdir results
mkdir results/megaprs

models=("lasso" "ridge" "bolt" "bayesr")

for model in "${models[@]}"; do
    
    mkdir results/megaprs/$model
    out="results/megaprs/$model/$model"

    ./ldak --mega-prs $out \
        --model $model \
        --summary data/sumstats/sumstats.txt \
        --ind-hers results/snphers/sumher.ind.hers \
        --cors results/cors/cors \
        --check-high-LD NO \
        --cv-proportion .1 \
        --window-kb 1000 \
        --allow-ambiguous YES \
        --extract data/sumstats/snps.list \
        --max-threads 6
        
done

