dat <- read.table("data/target/qc/geno2.het.het", header=T, comment.char = "") # Read in the EUR.het file, specify it has header
m <- mean(dat$F) # Calculate the mean
s <- sd(dat$F) # Calculate the SD
valid <- subset(dat, F <= m+3*s & F >= m-3*s) # Get any samples with F coefficient within 3 SD of the population mean
write.table(valid[,c(1,2)], "data/target/qc/geno2.het.valid.fam", quote=F, row.names=F) # print FID and IID for valid samples
q() # exit R
