#!/bin/bash
#SBATCH --account farzamani
#SBATCH -c 6
#SBATCH --mem 4g

# Print number of SNPs
echo "Number of SNPs in raw data:"
zcat data/preprocessed/sumstats.txt.gz | wc -l

# SNPs duplicate check
echo "Removing duplicate SNPs..."
zcat data/preprocessed/sumstats.txt.gz | \
    awk '{seen[$1]++; if(seen[$1]==1) {print}}' | \
    gzip - > data/preprocessed/sumstats.nodup.gz
echo "Removing duplicate SNPs... Done"

echo "SNPs left:"
zcat data/preprocessed/sumstats.nodup.gz | wc -l

# Removing low MAF
echo "Removing low MAF..."
zcat data/preprocessed/sumstats.nodup.gz | \
    awk 'NR==1 || ($7 > 0.01) {print}' | \
    gzip > data/preprocessed/sumstats.maf.gz
echo "Removing low MAF... Done"

echo "SNPs left:"
zcat data/preprocessed/sumstats.maf.gz | wc -l

# Removing ambiguous SNPs
echo "Removing ambiguous SNPs..."
zcat data/preprocessed/sumstats.maf.gz | \
    awk 'NR==1 || length($2) == 1 && length($3) == 1 && \
        !( ($2=="A" && $3=="T") || \
        ($2=="T" && $3=="A") || \
        ($2=="G" && $3=="C") || \
        ($2=="C" && $3=="G")) {print}' > data/sumstats/sumstats.txt
echo "Removing ambiguous SNPs... Done"

# Print number of SNPs
echo "Number of SNPs in QCed data:"
cat data/sumstats/sumstats.txt | wc -l

echo "Deleting temporary file ..."
rm data/preprocessed/sumstats.nodup.gz
rm data/preprocessed/sumstats.maf.gz

echo "Extracting SNPs..."
awk < data/sumstats/sumstats.txt 'NR>1 {print $1}' \
    > data/sumstats/snps.list