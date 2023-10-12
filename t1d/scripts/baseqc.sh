# Print number of SNPs
echo "Number of SNPs in raw data:"
less data/preprocessed/raw_sumstats.txt.gz | wc -l

# SNPs duplicate check
echo "Removing duplicate SNPs..."
gunzip -c data/preprocessed/raw_sumstats.txt.gz |\
awk '{seen[$1]++; if(seen[$1]==1) {print}}' |\
gzip - > data/preprocessed/sumstats.nodup.gz
echo "Removing duplicate SNPs... Done"

echo "SNPs left:"
less data/preprocessed/sumstats.nodup.gz | wc -l

# Removing low MAF
echo "Removing low MAF..."
gunzip -c data/preprocessed/sumstats.nodup.gz |\
awk 'NR==1 || ($7 > 0.01) {print}' |\
gzip > data/preprocessed/sumstats.maf.gz
echo "Removing low MAF... Done"

echo "SNPs left:"
less data/preprocessed/sumstats.maf.gz | wc -l

# Removing ambiguous SNPs
echo "Removing ambiguous SNPs..."
gunzip -c data/preprocessed/sumstats.maf.gz |\
awk 'length($2) == 1 && length($3) == 1 && \
        !( ($2=="A" && $3=="T") || \
        ($2=="T" && $3=="A") || \
        ($2=="G" && $3=="C") || \
        ($2=="C" && $3=="G")) {print}' |\
    gzip > data/sumstats.txt.gz
echo "Removing ambiguous SNPs... Done"

# Print number of SNPs
echo "Number of SNPs in QCed data:"
less data/sumstats.txt.gz | wc -l