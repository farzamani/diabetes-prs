
zcat data/finngen/finngen_R9_T1D_WIDE.gz | awk -F "\t" '$5 != ""' | \
    gzip > data/finngen/finngen_R9_T1D_WIDE.filtered.gz

# Make bed file after the sumstats filted (removing SNPs with no rsids)
zcat t1d/data/finngen/finngen_R9_T1D_WIDE.filtered.gz | \
    awk -F '\t' 'NR>1 {print "chr"$1,$2,$2+1,$5}' > t1d/data/finngen/finngen_R9_T1D_WIDE.bed

./liftOver t1d/data/finngen/finngen_R9_T1D_WIDE.bed \
    liftover/hg38ToHg19.over.chain.gz \
    t1d/data/finngen/finngen_R9_T1D_WIDE.out.bed \
    t1d/data/finngen/finngen_R9_T1D_WIDE.unlifted.bed

sortBed -i data/finngen/finngen_R9_T1D_WIDE.out.bed > data/finngen/finngen_R9_T1D_WIDE.sorted.out.bed

| gzip > liftOvered/finngen_R9_T1D_WIDE.txt.gz

zcat data/finngen/finngen_R9_T1D_WIDE.filtered.gz | \
    awk 'BEGIN {OFS=FS="\t"} NR==FNR { liftover[$4] = $0; next } \
    NR>1 { if ($5 in liftover) { split(liftover[$5], fields, "\t"); \
    $1=fields[1]; $2=fields[2]; $3=fields[3]; $5=fields[4]; } print }' \
    data/finngen/finngen_R9_T1D_WIDE.sorted.out.bed - | gzip > liftOvered/finngen_R9_T1D_WIDE.txt.gz

# Remove the "" from sumstats 
zcat data/liftovered/sumstats.txt.gz | awk -F '\t' 'BEGIN{OFS="\t"} {gsub(/"/, "", $0); gsub(/'\''/, "", $0); print}' | gzip > data/preprocessed/sumstats.txt.gz

srun --account dsmwpred --mem 16g -c 8 --time 04:00:00 --pty bash

cat data/reference/1000G.404EUR.bim | awk '{print $2}' > data/reference/snps.list

comm -12 data/reference/snps.list data/sumstats/snps.list > snps.common

# Flow for t2d
./liftOver t2d/data/finngen/finngen_R9_T2D_WIDE.bed \
    liftover/hg38ToHg19.over.chain.gz \
    t2d/data/finngen/finngen_R9_T2D_WIDE.out.bed \
    t2d/data/finngen/finngen_R9_T2D_WIDE.unlifted.bed

#diseases   control cases
#T1D    308373 8967
#T2D    310131  38657