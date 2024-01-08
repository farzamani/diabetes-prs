library(ggplot2)
library(dplyr)
library(qqman)
library(data.table)

linreg <- fread(input = file.path(getwd(), "linreg", "linreg.assoc"), data.table = FALSE, index = FALSE)

names(linreg) <- c("chr",
                   "rsids",
                   "pos",
                   "a1",
                   "a2",
                   "Wald_Stat",
                   "p",
                   "b",
                   "seb",
                   "Effect_Liability",
                   "SD_Liability",
                   "a1_mean",
                   "maf")

linreg$chr <- as.numeric(linreg$chr)
linreg$pos <- as.numeric(linreg$pos)

linreg <- linreg %>% 
  select("chr",
         "rsids",
         "pos",
         "a1",
         "a2",
         "p",
         "b",
         "seb",
         "a1_mean",
         "maf") %>% 
  filter(maf > 0.01) %>% 
  filter(p > 0) %>%
  distinct(rsids, .keep_all = TRUE) %>% 
  filter(  !(a1 == "A" & a2 == "T")& 
           !(a1 == "T" & a2 == "A")&
           !(a1 == "C" & a2 == "G")& 
           !(a1 == "G" & a2 == "C"))

# Open a PNG graphics device for saving the plot
png("figures/manhattan.png", width = 14, height = 7, units = "in", res = 300)

manhattan(linreg,
        chr = "chr",
        bp = "pos",
        p = "p",
        snp = "rsids",
        annotatePval = 5e-8,
        main = "Manhattan Plot", 
        col = c("blue4", "orange3"))

# Save the current plot
print("Saving figure")
dev.off()