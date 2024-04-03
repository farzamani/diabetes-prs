library(ggplot2)
library(dplyr)

models = c("lasso", "ridge","bolt", "bayesr")
scores <- data.frame()

for (model in models) {
    score <- read.csv(file.path(getwd(), "results", "megaprs", model, "score.cors"), header = T,  sep = "\t")
    score$model <- model
    scores <- rbind(scores, score)
}

# Open a PNG graphics device for saving the plot
png("figures/megaprs.png", width = 7, height = 7, units = "in", res = 300)

ggplot(scores, aes(x = model, y = Correlation, fill = model)) +
  geom_bar(stat = "identity") +
  labs(x = "Model", y = "Correlation") +
  ggtitle("Correlation by Model") +
  theme_minimal()

# Save the current plot
print("Saving figure")
dev.off()