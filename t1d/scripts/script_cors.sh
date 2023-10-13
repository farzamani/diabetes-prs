#!/bin/bash
#SBATCH --account dsmwpred
#SBATCH -c 6
#SBATCH --mem 16g

mkdir results
mkdir results/cors

./ldak --calc-cors results/cors/cors \
    --bfile data/reference/1000G.404EUR \
    --window-kb 1000 \
    --max-threads 6