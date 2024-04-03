library(dplyr)
library(qqman)
library(data.table)

linreg <- fread(input = file.path(getwd(), "sumstats.t2d.txt"), data.table = FALSE, index = FALSE)

split_data <- strsplit(linreg$Predictor, ":")
linreg$chr <- sapply(split_data, function(x) x[1])
linreg$pos <- sapply(split_data, function(x) x[2])

linreg$chr <- as.numeric(linreg$chr)
linreg$pos <- as.numeric(linreg$pos)

names(linreg) <- c("Predictor",
                   "a1",
                   "a2",
                   "rsids",
                   "b",
                   "p",
                   "maf",
                   "n",
                   "chr",
                   "pos")

linreg <- linreg %>% 
  select("chr",
         "rsids",
         "pos",
         "a1",
         "a2",
         "p",
         "b",
         "maf") %>% 
  filter(maf > 0.01) %>% 
  filter(p > 0) %>%
  distinct(rsids, .keep_all = TRUE) %>% 
  filter(  !(a1 == "A" & a2 == "T")& 
           !(a1 == "T" & a2 == "A")&
           !(a1 == "C" & a2 == "G")& 
           !(a1 == "G" & a2 == "C"))

# Open a PNG graphics device for saving the plot
png("figures/t2d_manhattan.png", width = 8, height = 5, units = "in", res = 300)

manhattan(linreg,
        chr = "chr",
        bp = "pos",
        p = "p",
        snp = "rsids",
        annotatePval = 5e-8,
        ylim = c(0, 40),
        main = "Manhattan Plot", 
        col = c("blue4", "orange3"))

# Save the current plot
print("Saving figure")
dev.off()