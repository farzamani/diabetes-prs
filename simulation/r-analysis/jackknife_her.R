library(ggplot2)
library(dplyr)
source("../ggplot_theme_Publication.R")

models <- c("lasso", "ridge", "bolt", "bayesr")
causal_snps_dirs <- c("results her0.2", "results her0.5", "results her0.8")
scores <- data.frame()

for (snps_dir in causal_snps_dirs) {
    for (model in models) {
        file_path <- file.path(getwd(), snps_dir, "megaprs", model, "jackknife.jack")
        if (file.exists(file_path)) {
            score <- read.csv(file_path, header = TRUE, sep = " ")
            score$model <- model
            # Extract only the numeric part of snps_dir
            score$snps_dir <- sub("results her", "", snps_dir)
            scores <- rbind(scores, score)
        }
    }
}

df_corr <- scores %>%
  filter(Measure == "Correlation") %>%
  select(snps_dir, model, Estimate, SD)

df_liability <- scores %>%
  filter(Measure == "Liability_squared_correlation") %>%
  select(snps_dir, model, Estimate, SD)

df_auc <- scores %>%
  filter(Measure == "Area_under_curve") %>%
  select(snps_dir, model, Estimate, SD)

################################################################
# Plotting Correlation
################################################################
# png("figures/her_corr.png", width = 8, height = 5, units = "in", res = 300)

plot1 <- ggplot(df_corr, aes(x = snps_dir, y = Estimate, fill = snps_dir)) +
  geom_bar(stat = "identity", position = position_dodge(width = 0.8)) +
  geom_errorbar(aes(ymin = Estimate - SD, ymax = Estimate + SD), width = .2, position = position_dodge(width = 0.8)) +
  geom_text(aes(label = sprintf("%.5f", Estimate)), vjust = 3, position = position_dodge(0.9), size = 2) +
  facet_grid(~model) +
  labs(
    title = "Heritability Effect on Polygenic Risk Scores",
    fill = "Heritability",
    x = "Model",
    y = "Correlation Estimate") +
  theme_tufte() + scale_fill_Publication()

# print("Saving figure")
# dev.off()

################################################################
# Plotting Liability
################################################################
# Open a PNG graphics device for saving the plot
# png("figures/her_liability.png", width = 8, height = 5, units = "in", res = 300)

plot2 <- ggplot(df_liability, aes(x = snps_dir, y = Estimate, fill = snps_dir)) +
  geom_bar(stat = "identity", position = position_dodge(width = 0.8)) +
  geom_errorbar(aes(ymin = Estimate - SD, ymax = Estimate + SD), width = .2, position = position_dodge(width = 0.8)) +
  geom_text(aes(label = sprintf("%.5f", Estimate)), vjust = -2.5, position = position_dodge(0.9), size = 2) +
  facet_grid(~model) +
  labs(
    fill = "Heritability",
    x = "Model",
    y = "Liability Squared Correlation Estimate") +
  theme_tufte() + scale_fill_Publication()

# Save the current plot
# print("Saving figure")
# dev.off()

################################################################
# Plotting AUC
################################################################
# Open a PNG graphics device for saving the plot
# png("figures/her_AUC.png", width = 8, height = 5, units = "in", res = 300)

plot3 <- ggplot(df_auc, aes(x = snps_dir, y = Estimate, fill = snps_dir)) +
  geom_bar(stat = "identity", position = position_dodge(width = 0.8)) +
  geom_errorbar(aes(ymin = Estimate - SD, ymax = Estimate + SD), width = .2, position = position_dodge(width = 0.8)) +
  geom_text(aes(label = sprintf("%.5f", Estimate)), vjust = 5, position = position_dodge(0.9), size = 2) +
  facet_grid(~model) +
  labs(
    fill = "Heritability",
    x = "Model",
    y = "AUC Estimate") +
  theme_tufte() + scale_fill_Publication()

# Save the current plot
# print("Saving figure")
# dev.off()

####################################################################
# Combination
####################################################################

# Combine the plots side by side
# Open a PNG graphics device for saving the plot
png("figures/hers.png", width = 8, height = 8, units = "in", res = 300)

combined_plot <- grid.arrange(plot1, plot2, plot3, nrow = 3)

# Save the current plot
print("Saving figure")
dev.off()

# setwd("../simulation")