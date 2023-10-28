dat <- read.table("data/target/chr6.het.het", header=T, comment.char = "") # Read in the EUR.het file, specify it has header
m <- mean(dat$V6) # Calculate the mean  
s <- sd(dat$V6) # Calculate the SD
valid <- subset(dat, V6 <= m+3*s & V6 >= m-3*s) # Get any samples with F coefficient within 3 SD of the population mean
write.table(valid[,c(1,2)], "data/test/chr6.het.valid", quote=F, row.names=F) # print FID and IID for valid samples
q() # exit R
