# Removing row with empty rsids
zcat data/finngen/finngen_R9_T2D_WIDE.gz | awk -F "\t" '$5 != ""' | \
    gzip > data/finngen/finngen_R9_T2D_WIDE.filtered.gz

# Make bed file after the sumstats filtered (removing SNPs with no rsids)
zcat data/finngen/finngen_R9_T2D_WIDE.filtered.gz | \
    awk -F '\t' 'NR>1 {print "chr"$1,$2,$2+1,$5}' > data/finngen/finngen_R9_T2D_WIDE.bed

# Make a liftovered bed file
./liftOver t2d/data/finngen/finngen_R9_T2D_WIDE.bed \
    liftover/hg38ToHg19.over.chain.gz \
    t2d/data/finngen/finngen_R9_T2D_WIDE.out.bed \
    t2d/data/finngen/finngen_R9_T2D_WIDE.unlifted.bed

# Sort the liftovered bed file
sortBed -i data/finngen/finngen_R9_T2D_WIDE.out.bed > data/finngen/finngen_R9_T2D_WIDE.sorted.out.bed

# Run Rscript
Rscript liftover.R

# Remove the "" from sumstats 
cat data/liftovered/sumstats.txt | awk -F '\t' 'BEGIN{OFS="\t"} {gsub(/"/, "", $0); gsub(/'\''/, "", $0); print}' | gzip > data/preprocessed/sumstats.txt.gz