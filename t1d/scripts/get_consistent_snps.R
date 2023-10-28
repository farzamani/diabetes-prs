snps_cors <- read.table("data/snps/snps.cors")
snps_sumstats <- read.table("data/snps/snps.sumstats")

merged <- merge(snps_cors, snps_sumstats, by = "V1")

consistent_alleles <- merged[merged$V2.x == merged$V2.y & merged$V3.x == merged$V3.y, ]

head(merged)
nrow(snps_cors)
nrow(snps_sumstats)

nrow(merged)
nrow(consistent_alleles)
q()