
zcat data/finngen/finngen_R9_T1D_WIDE.gz | awk -F "\t" '$5 != ""' | \
    gzip > data/finngen/finngen_R9_T1D_WIDE.filtered.gz

# Make bed file after the sumstats filted (removing SNPs with no rsids)
zcat data/finngen/finngen_R9_T1D_WIDE.filtered.gz | \
    awk -F '\t' 'NR>1 {print "chr"$1,$2,$2+1,$5}' > data/finngen/finngen_R9_T1D_WIDE.bed

./liftOver data/finngen/finngen_R9_T1D_WIDE.bed \
    ../liftover/hg38ToHg19.over.chain.gz \
    data/finngen/finngen_R9_T1D_WIDE.out.bed \
    data/finngen/finngen_R9_T1D_WIDE.unlifted.bed

sortBed -i data/finngen/finngen_R9_T1D_WIDE.out.bed > data/finngen/finngen_R9_T1D_WIDE.sorted.out.bed

# Remove the "" from sumstats 
cat data/liftovered/sumstats.txt | awk -F '\t' 'BEGIN{OFS="\t"} {gsub(/"/, "", $0); gsub(/'\''/, "", $0); print}' | gzip > data/preprocessed/sumstats.txt.gz

# srun --account dsmwpred --mem 16g -c 8 --time 04:00:00 --pty bash