# Read in file
valid <- read.table(snakemake@input$het, header=T)
dat <- read.table(snakemake@input$sex, header=T)
valid <- subset(dat, STATUS=="OK" & FID %in% valid$FID)
write.table(valid[,c("FID", "IID")], snakemake@output$valid, row.names=F, col.names=F, sep="\t", quote=F) 
q() # exit R