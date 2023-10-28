#!/bin/bash
#SBATCH --account dsmwpred
#SBATCH -c 8
#SBATCH --mem 32g

# mkdir data/preprocessed

# Create a file that fit the LDAK format
# zcat data/raw/250.1_PheCode.v1.0.fastGWA.gz | \
# awk 'BEGIN {print "Predictor\tA1\tA2\tDirection\tP\tn\tAF\tZ"}
#     NR>1 {
#     OFS="\t";
#     predictor=$1 ":" $3;
#     rsids=$2
#     A1=$4;
#     A2=$5;
#     beta=$11;
#     se=$12;
#     p=$13
#     Z=beta/se;
#     n=$6;
#     af=$7;
#     print predictor, A1, A2, beta, p, n, af, Z, rsids}' | gzip -c > data/preprocessed/sumstats.txt.gz

# Create a file that fit the LDAK format
# cat data/raw/GCST90014023_buildGRCh38.tsv | \
# awk 'BEGIN {print "Predictor\tA1\tA2\tDirection\tP\tAF\tZ\trsids\tn"}
#     NR>1 {
#     OFS="\t";
#     predictor=$3 ":" $4;
#     rsids=$1;
#     A1=$6;
#     A2=$5;
#     beta=$8;
#     se=$9;
#     p=$2;
#     Z=beta/se;
#     n=$10;
#     af=$7;
#     print predictor, A1, A2, beta, p, af, Z, rsids, n}' > data/preprocessed/sumstats1.txt

# zcat data/raw/34012112-GCST90014023-EFO_0001359.h.tsv.gz | \
# awk 'BEGIN {print "Predictor\tA1\tA2\tDirection\tP\tAF\tZ\trsids"}
#     NR>1 && $2 == $13 && $3 == $15 && $4 == $16 {
#     OFS="\t";
#     predictor=$3":"$4;
#     rsids=$2;
#     A1=$5;
#     A2=$6;
#     beta=$7;
#     se=$21;
#     p=$14;
#     Z=beta/se;
#     af=$11;
#     print predictor, A1, A2, beta, p, af, Z, rsids}' > data/preprocessed/sumstats2.txt

# awk 'BEGIN {OFS="\t"} NR==FNR {a[$1,$2,$3,$8]=$9; next} ($1,$2,$3,$8) in a {print $1, $2, $3, $4, $5, $6, $7, $8, a[$1,$2,$3,$8]}' data/preprocessed/sumstats1.txt data/preprocessed/sumstats2.txt | gzip > data/preprocessed/sumstats.merged.txt.gz

zcat data/raw/T1D_meta_FinnGen_r3_T1D_STRICT.all_chr.hg19.sumstats.txt.gz |  \
awk 'BEGIN {print "Predictor\tA1\tA2\tDirection\tP\tAF\tZ\tn"}
    NR>1 {
    OFS="\t";
    split($1, a, ":");
    predictor=a[1]":"a[2];
    rsids=NA;
    A1=a[4];
    A2=a[3];
    beta=$6;
    se=$7;
    p=$8;
    Z=beta/se;
    af=$12;
    n=$9;
    print predictor, A1, A2, beta, p, af, Z, n}' | gzip > data/preprocessed/sumstats.txt.gz

echo "Completed!"
# zcat T1D_meta_FinnGen_r3_T1D_STRICT.all_chr.hg19.sumstats.txt.gz | head -n 1000000 | awk 'NR==1 || (NR>1 && $3 != $15 && $4 != $16) {print}' | gzip > inconsistent.log.gz
# zcat data/raw/34012112-GCST90014023-EFO_0001359.h.tsv.gz | awk 'NR>1 && $3 != $15 && $4 != $16 {print $2, $3":"$4, $13, $15":"$16}' | gzip > inconsistent.log.gz
# zcat T1D_meta_FinnGen_r3_T1D_STRICT.all_chr.hg19.sumstats.txt.gz | head -n 1000000 | awk 'NR==1 || (NR>1 && $1 != $15) {print $1, $15}' | gzip > inconsistent.log.gz
