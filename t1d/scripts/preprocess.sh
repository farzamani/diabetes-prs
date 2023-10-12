# Create a file that fit the LDAK format
zcat data/raw/250.1_PheCode.v1.0.fastGWA.gz | \
awk 'BEGIN {print "Predictor\tA1\tA2\tDirection\tP\tn\tAF\tZ"}
    NR>1 {
    OFS="\t";
    predictor=$1 ":" $3;
    A1=$4;
    A2=$5;
    beta=$11;
    se=$12;
    p=$13
    Z=beta/se;
    n=$6;
    af=$7;
    print predictor, A1, A2, beta, p, n, af, Z}' | gzip -c > data/preprocessed/raw_sumstats.txt.gz