icd <- read.delim("icd.txt", sep = " ", header = TRUE)
colnames(icd) <- gsub("^X", "", colnames(icd))

t1d <- c("E10", "E100", "E101", "E102", "E103", "E104",
         "E105", "E106", "E107", "E108", "E109")
t2d <- c("E11", "E110", "E111", "E112", "E113", "E114",
         "E115", "E116", "E117", "E118", "E119")

# Initialize a new data frame to store the result
t1d.pheno <- data.frame(eid = icd$eid, eid2 = icd$eid)
t2d.pheno <- data.frame(eid = icd$eid, eid2 = icd$eid)

# Check each column for values in t1d and accumulate the results
t1d.pheno$phenotype <- apply(icd[-1], 1, function(row) as.integer(any(row %in% t1d)))
t2d.pheno$phenotype <- apply(icd[-1], 1, function(row) as.integer(any(row %in% t2d)))

# Save phenotype files
write.table(t1d.pheno, file = "t1d.pheno", sep = "\t", row.names = FALSE, col.names = FALSE)
write.table(t2d.pheno, file = "t2d.pheno", sep = "\t", row.names = FALSE, col.names = FALSE)

q()