t1d <- read.delim("t1d.pheno", sep = "\t", header = FALSE)
t2d <- read.delim("t2d.pheno", sep = "\t", header = FALSE)

t1d_ncase <- sum(t1d$V3)
t1d_ncontrol <- length(t1d$V3) - t1d_ncase

print(t1d_ncase)
print(t1d_ncontrol)

t2d_ncase <- sum(t2d$V3)
t2d_ncontrol <- length(t2d$V3) - t2d_ncase

print(t2d_ncase)
print(t2d_ncontrol)

q()
