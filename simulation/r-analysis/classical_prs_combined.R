library(ggplot2)
library(dplyr)

score50 <- read.csv(file.path(getwd(), "results snps50", "classical", "results.txt"), header = F)
score200 <- read.csv(file.path(getwd(), "results snps200", "classical", "results.txt"), header = F)
score1000 <- read.csv(file.path(getwd(), "results snps1000", "classical", "results.txt"), header = F)

# Define pvalues
pvalues <- c(5e-8, 1e-7, 1e-6, 1e-5, 1e-4, 1e-3, 1e-2, 0.1, 1)
len <- length(pvalues)

# Create new data frames with an additional 'causal' column for "thin" type only
scores50 <- data.frame(
  causal = rep("50", len),
  pvalue = pvalues,
  value = score50$V1[(len + 1):(2 * len)]
)

scores200 <- data.frame(
  causal = rep("200", len),
  pvalue = pvalues,
  value = score200$V1[(len + 1):(2 * len)]
)

scores1000 <- data.frame(
  causal = rep("1000", len),
  pvalue = pvalues,
  value = score1000$V1[(len + 1):(2 * len)]
)

# Combine all scores into one dataframe
scores <- rbind(scores50, scores200, scores1000)

# Open a PNG graphics device for saving the plot
png("figures/classical_prs_thin.png", width = 6, height = 4, units = "in", res = 300)

# Create a ggplot line plot for "thin" type
ggplot(scores, aes(x = pvalue, y = value, group = causal)) +
  geom_line(aes(color = causal), linewidth = 1) +
  scale_x_log10() +  # Use a logarithmic x-axis scale
  labs(
    title = "Classical PRS: Simulated Data",
    subtitle = "Comparing causal SNPs effect on PRS",
    x = "P-Value", 
    y = "Correlation",
    color = "Causal SNPs") +
  theme_minimal()

# Save the current plot
print("Saving figure")
dev.off()
