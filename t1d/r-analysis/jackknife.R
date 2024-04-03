library(ggplot2)
library(dplyr)
library(ggthemes)
source("../ggplot_theme_Publication.R")

models <- c("lasso", "ridge", "bolt", "bayesr")
scores <- data.frame()

for (model in models) {
    score <- read.csv(file.path(getwd(), "results", "megaprs", model, "jackknife.jack"), header = T,  sep = " ")
    score$model <- model
    scores <- rbind(scores, score)
}

df_corr <- scores %>%
  filter(Measure == "Correlation") %>%
  select(model, Estimate, SD)

df_liability <- scores %>%
  filter(Measure == "Liability_squared_correlation") %>%
  select(model, Estimate, SD)

df_auc <- scores %>%
  filter(Measure == "Area_under_curve") %>%
  select(model, Estimate, SD)

################################################################
# Plotting Correlation
################################################################
# Open a PNG graphics device for saving the plot
# png("figures/t1d_corr.png", width = 7, height = 5, units = "in", res = 300)

plot1 <- ggplot(df_corr, aes(x = model, y = Estimate, fill = model)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  geom_errorbar(aes(ymin = Estimate - SD, ymax = Estimate + SD),
                width = .2, position = position_dodge(.9)) +
  geom_hline(yintercept = 0.039929, linetype="dotted", size = 0.8) +
  geom_text(aes(label = sprintf("%.5f", Estimate)), vjust = 5, position = position_dodge(0.9), size = 2) +
  labs(title = "Correlation",
      subtitle = "PRS of T1D",
       x = "Model",
       y = "Estimate") +
  theme_tufte() + scale_fill_Publication()

# Save the current plot
# print("Saving figure")
# dev.off()

################################################################
# Plotting Liability
################################################################
# Open a PNG graphics device for saving the plot
# png("figures/t1d_liability.png", width = 7, height = 5, units = "in", res = 300)

plot2 <- ggplot(df_liability, aes(x = model, y = Estimate, fill = model)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  geom_errorbar(aes(ymin = Estimate - SD, ymax = Estimate + SD), 
                width = .2, position = position_dodge(.9)) +
  geom_hline(yintercept = 0.030655, linetype="dotted", size = 0.8) +
  geom_text(aes(label = sprintf("%.5f", Estimate)), vjust = 6, position = position_dodge(0.9), size = 2) +
  labs(title = "Liability R2",
       x = "Model",
       y = "Estimate") +
  theme_tufte() + scale_fill_Publication()

# Save the current plot
# print("Saving figure")
# dev.off()

################################################################
# Plotting AUC
################################################################
# Open a PNG graphics device for saving the plot
# png("figures/t1d_AUC.png", width = 7, height = 5, units = "in", res = 300)

plot3 <- ggplot(df_auc, aes(x = model, y = Estimate, fill = model)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  geom_errorbar(aes(ymin = Estimate - SD, ymax = Estimate + SD), 
                width = .2, position = position_dodge(.9)) +
  geom_hline(yintercept = 0.605570, linetype="dotted", size = 0.8) +
  geom_text(aes(label = sprintf("%.5f", Estimate)), vjust = 5, position = position_dodge(0.9), size = 2) +
  labs(title = "Area Under the Curve",
       x = "Model",
       y = "Estimate") +
  theme_tufte() + scale_fill_Publication()

# Save the current plot
# print("Saving figure")
# dev.off()

####################################################################
# Combination
####################################################################

# Combine the plots side by side
# Open a PNG graphics device for saving the plot
png("figures/t1d_jackknife_combined_ldak.png", width = 10, height = 4, units = "in", res = 300)

combined_plot <- grid.arrange(plot1, plot2, plot3, ncol = 3)

# Save the current plot
print("Saving figure")
dev.off()

# setwd("../t2d")