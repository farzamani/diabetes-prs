library(ggplot2)
library(dplyr)

score <- read.csv(file.path(getwd(), "results", "classical", "results.txt"), header = F)

# Define pvalues
pvalues <- c(5e-8, 1e-7, 1e-6, 1e-5, 1e-4, 1e-3, 1e-2, 0.1, 1)
len <- length(pvalues)

# Create a new data frame
scores <- data.frame(
  pvalue = pvalues,
  just = score$V1[1:len],
  thin = score$V1[(len + 1):(2 * len)]
)

# Open a PNG graphics device for saving the plot
png("figures/classical_prs.png", width = 14, height = 7, units = "in", res = 300)

# Create a ggplot line plot
ggplot(scores, aes(x = pvalue)) +
  geom_line(aes(y = just, color = "just"), linewidth = 1) +
  geom_line(aes(y = thin, color = "thin"), linewidth = 1) +
  scale_x_log10() +  # Use a logarithmic x-axis scale
  labs(
    title = "Classical PRS: Just vs Thin",
    x = "pvalue", 
    y = "Value") +
  scale_color_manual(values = c("just" = "blue", "thin" = "red")) +  # Specify line colors
  theme_minimal()

# Save the current plot
print("Saving figure")
dev.off()