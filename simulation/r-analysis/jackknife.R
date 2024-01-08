library(ggplot2)
library(dplyr)

models <- c("lasso", "ridge", "bolt", "bayesr")
causal_snps_dirs <- c("results snps50", "results snps200", "results snps1000")
scores <- data.frame()

for (snps_dir in causal_snps_dirs) {
    for (model in models) {
        file_path <- file.path(getwd(), snps_dir, "megaprs", model, "jackknife.jack")
        if (file.exists(file_path)) {
            score <- read.csv(file_path, header = TRUE, sep = " ")
            score$model <- model
            # Extract only the numeric part of snps_dir
            score$snps_dir <- sub("results snps", "", snps_dir)
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
png("figures/corr.png", width = 8, height = 5, units = "in", res = 300)

ggplot(df_corr, aes(x = snps_dir, y = Estimate, fill = snps_dir)) +
  geom_bar(stat = "identity", position = position_dodge(width = 0.8)) +
  geom_errorbar(aes(ymin = Estimate - SD, ymax = Estimate + SD), width = .2, position = position_dodge(width = 0.8)) +
  facet_grid(~model) +
  labs(title = "Correlation Estimates of Polygenic Risk Scores by Model",
       fill = "Causal SNPs",
       x = "Model",
       y = "Correlation Estimate") +
  theme_minimal()

print("Saving figure")
dev.off()

################################################################
# Plotting Liability
################################################################
# Open a PNG graphics device for saving the plot
png("figures/liability.png", width = 8, height = 5, units = "in", res = 300)

ggplot(df_liability, aes(x = snps_dir, y = Estimate, fill = snps_dir)) +
  geom_bar(stat = "identity", position = position_dodge(width = 0.8)) +
  geom_errorbar(aes(ymin = Estimate - SD, ymax = Estimate + SD), width = .2, position = position_dodge(width = 0.8)) +
  facet_grid(~model) +
  labs(title = "Liability Squared Correlation Estimates of Polygenic Risk Scores",
       fill = "Causal SNPs",
       x = "Model",
       y = "Liability Squared Correlation Estimate") +
  theme_minimal()

# Save the current plot
print("Saving figure")
dev.off()

################################################################
# Plotting AUC
################################################################
# Open a PNG graphics device for saving the plot
png("figures/AUC.png", width = 8, height = 5, units = "in", res = 300)

ggplot(df_auc, aes(x = snps_dir, y = Estimate, fill = snps_dir)) +
  geom_bar(stat = "identity", position = position_dodge(width = 0.8)) +
  geom_errorbar(aes(ymin = Estimate - SD, ymax = Estimate + SD), width = .2, position = position_dodge(width = 0.8)) +
  facet_grid(~model) +
  labs(title = "Area Under the Curve of Polygenic Risk Scores",
       fill = "Causal SNPs",
       x = "Model",
       y = "AUC Estimate") +
  theme_minimal()

# Save the current plot
print("Saving figure")
dev.off()