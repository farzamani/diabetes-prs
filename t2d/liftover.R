library(dplyr)

# Load data
print("Loading data...")
data <- read.delim(gzfile("data/finngen/finngen_R9_T2D_WIDE.filtered.gz"), sep = "\t", header = TRUE)
bed <- read.delim("data/finngen/finngen_R9_T2D_WIDE.sorted.out.bed", sep = "\t", header = FALSE)

# Merge data
print("Merging data...")
merged <- merge(data, bed, by.x = "rsids", by.y = "V4", all.x = TRUE)
sorted_merged <- merged[order(merged$X.chrom, merged$pos), ]
sorted_merged <- sorted_merged %>% na.omit()

print("Formatting data...")
sorted_merged$V1 <- sub("chr", "", sorted_merged$V1)
sorted_merged$n <- 310131 + 38657
sorted_merged$maf <- pmin(sorted_merged$af_alt, 1 - sorted_merged$af_alt)
sorted_merged$pred <- paste(sorted_merged$V1, ":", sorted_merged$V2, sep="")
sorted_merged$Z <- sorted_merged$beta / sorted_merged$sebeta

sorted_merged_final <- sorted_merged[order(sorted_merged$V1, sorted_merged$V2), ]


sumstats <- sorted_merged_final %>% 
  select(pred, alt, ref, rsids, Z, beta, pval, maf, n)


colnames(sumstats) <- c("Predictor", "A1", "A2", "rsids", "Z", "Direction", "P", "maf", "n")

# mismatch <- sorted_merged$pos != sorted_merged$V2
# sum(mismatch)
# colSums(is.na(sorted_merged))
# colSums(is.na(sumstats))
# head(sorted_merged)
head(sumstats)
nrow(sumstats)

print("Writing data...")
write.table(sumstats, file = "data/liftovered/sumstats.txt", sep = "\t", row.names = FALSE, col.names = TRUE)
# write.table(sumstats$Predictor, file = "data/liftovered/snps.list", sep = "\t", row.names = FALSE, col.names = FALSE)
# write.table(sumstats$rsids, file = "data/liftovered/rsids.list", sep = "\t", row.names = FALSE, col.names = FALSE)

q()