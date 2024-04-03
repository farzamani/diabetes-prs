library(ggplot2)
library(dplyr)
library(ggthemes)
library(gridExtra)
source("../ggplot_theme_Publication.R")

# setwd("../t1d")

####################################################################
# Correlation
####################################################################

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
# png("figures/classical_prs_corr.png", width = 7, height = 5, units = "in", res = 300)

# Create a ggplot line plot
plot1 <- ggplot(scores, aes(x = pvalue)) +
  geom_line(aes(y = just, color = "No clumping"), linewidth = 1) +
  geom_line(aes(y = thin, color = "With clumping"), linewidth = 1) +
  scale_x_log10() +  # Use a logarithmic x-axis scale
  labs(
    title = "Classical PRS: Correlation",
    subtitle = "T1D: Comparison of With and Without Clumping",
    x = "P-Value", 
    y = "Correlation") +
  scale_color_manual(values = c("just" = "blue", "thin" = "red")) +  # Specify line colors
  theme_tufte() + scale_colour_Publication()

# Save the current plot
# print("Saving figure")
# dev.off()

####################################################################
# Liability r2
####################################################################

score <- read.csv(file.path(getwd(), "results", "classical", "liab.txt"), header = F)

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
# png("figures/classical_prs_liab.png", width = 7, height = 5, units = "in", res = 300)

# Create a ggplot line plot
plot2 <- ggplot(scores, aes(x = pvalue)) +
  geom_line(aes(y = just, color = "No clumping"), linewidth = 1) +
  geom_line(aes(y = thin, color = "With clumping"), linewidth = 1) +
  scale_x_log10() +  # Use a logarithmic x-axis scale
  labs(
    title = "Liability R2",
    x = "P-Value", 
    y = "Liability R2") +
  scale_color_manual(values = c("just" = "blue", "thin" = "red")) +  # Specify line colors
  theme_tufte() + scale_colour_Publication()

# Save the current plot
# print("Saving figure")
# dev.off()

####################################################################
# AUC
####################################################################

score <- read.csv(file.path(getwd(), "results", "classical", "auc.txt"), header = F)

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
# png("figures/classical_prs_auc.png", width = 7, height = 5, units = "in", res = 300)

# Create a ggplot line plot
plot3 <- ggplot(scores, aes(x = pvalue)) +
  geom_line(aes(y = just, color = "No clumping"), linewidth = 1) +
  geom_line(aes(y = thin, color = "With clumping"), linewidth = 1) +
  scale_x_log10() +  # Use a logarithmic x-axis scale
  labs(
    title = "Area Under Curve",
    x = "P-Value", 
    y = "AUC") +
  scale_color_manual(values = c("just" = "blue", "thin" = "red")) +  # Specify line colors
  theme_tufte() + scale_colour_Publication()

# Save the current plot
# print("Saving figure")
# dev.off()

####################################################################
# Combination
####################################################################

# Combine the plots side by side
# Open a PNG graphics device for saving the plot
png("figures/t1d_classical_prs_combined.png", width = 5, height = 7, units = "in", res = 300)

combined_plot <- grid.arrange(plot1, plot2, plot3, nrow = 3)

# Save the current plot
print("Saving figure")
dev.off()

# setwd("../t1d")