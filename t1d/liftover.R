library(dplyr)

# Load data
data <- read.delim(gzfile("data/finngen/finngen_R9_T1D_WIDE.filtered.gz"), sep = "\t", header = TRUE)
bed <- read.delim("data/finngen/finngen_R9_T1D_WIDE.sorted.out.bed", sep = "\t", header = FALSE)

# Merge data
merged <- merge(data, bed, by.x = "rsids", by.y = "V4", all.x = TRUE)
sorted_merged <- merged[order(merged$X.chrom, merged$pos), ]
sorted_merged <- sorted_merged %>% na.omit()

sorted_merged$V1 <- sub("chr", "", sorted_merged$V1)
sorted_merged$n <- 308373 + 8967
sorted_merged$maf <- pmin(sorted_merged$af_alt, 1 - sorted_merged$af_alt)
sorted_merged$pred <- paste(sorted_merged$V1, ":", sorted_merged$V2, sep="")
sorted_merged$Z <- sorted_merged$beta / sorted_merged$sebeta

sorted_merged_final <- sorted_merged[order(sorted_merged$V1, sorted_merged$V2), ]

sumstats <- sorted_merged_final %>%
  select(pred, alt, ref, rsids, beta, pval, maf, n) %>%
  filter(maf > 0.05)

colnames(sumstats) <- c("Predictor", "A1", "A2", "rsids", "Direction", "P", "maf", "n")

head(sumstats)
nrow(sumstats)

write.table(sumstats, file = "data/liftovered/sumstats.txt", sep = "\t", row.names = FALSE, col.names = TRUE)

q()