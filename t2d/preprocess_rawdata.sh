#!/bin/bash
#SBATCH --account dsmwpred
#SBATCH -c 8
#SBATCH --mem 32g

# Create a file that fit the LDAK format
cat data/raw/DIAMANTE-EUR.sumstat.txt | \
awk 'BEGIN {print "Predictor\tA1\tA2\tDirection\tP\tAF\tZ\trsids\tn"}
    NR>1 {
    OFS="\t";
    predictor=$1 ":" $2;
    rsids=$4;
    A1=toupper($5);
    A2=toupper($6);
    beta=$8;
    se=$9;
    p=$10;
    Z=beta/se;
    n=251740;
    af=$7;
    print predictor, A1, A2, beta, p, af, Z, rsids, n}' | gzip -c > data/preprocessed/sumstats.txt.gz

echo "Completed!"
