library(ggplot2)
library(dplyr)

score50 <- read.csv(file.path(getwd(), "results her0.2", "classical", "results.txt"), header = F)
score200 <- read.csv(file.path(getwd(), "results her0.5", "classical", "results.txt"), header = F)
score1000 <- read.csv(file.path(getwd(), "results her0.8", "classical", "results.txt"), header = F)

# Define pvalues
pvalues <- c(5e-8, 1e-7, 1e-6, 1e-5, 1e-4, 1e-3, 1e-2, 0.1, 1)
len <- length(pvalues)

# Create new data frames with an additional 'causal' column for "thin" type only
scores2 <- data.frame(
  her = rep("0.2", len),
  pvalue = pvalues,
  value = score50$V1[(len + 1):(2 * len)]
)

scores5 <- data.frame(
  her = rep("0.5", len),
  pvalue = pvalues,
  value = score200$V1[(len + 1):(2 * len)]
)

scores8 <- data.frame(
  her = rep("0.8", len),
  pvalue = pvalues,
  value = score1000$V1[(len + 1):(2 * len)]
)

# Combine all scores into one dataframe
scores <- rbind(scores2, scores5, scores8)

# Open a PNG graphics device for saving the plot
png("figures/classical_prs_her.png", width = 6, height = 4, units = "in", res = 300)

# Create a ggplot line plot for "thin" type
ggplot(scores, aes(x = pvalue, y = value, group = her)) +
  geom_line(aes(color = her), linewidth = 1) +
  scale_x_log10() +  # Use a logarithmic x-axis scale
  labs(
    title = "Classical PRS: Simulated Data",
    subtitle = "Comparing heritability effect on PRS",
    x = "P-Value", 
    y = "Correlation",
    color = "Heritability") +
  theme_minimal()

# Save the current plot
print("Saving figure")
dev.off()
