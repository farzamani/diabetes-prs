# Load necessary library
library(ggplot2)

# Assuming we have three genotype states (0, 1, 2)
# We will create a sample dataset with 100 observations for each state
set.seed(123) # For reproducibility
genotype_states <- rep(0:2, each = 100)
phenotype_values <- c(rnorm(100, mean = 0, sd = 0.1),   # State 0
                      rnorm(100, mean = 1, sd = 0.1),   # State 1
                      rnorm(100, mean = 2, sd = 0.1))   # State 2

# Create a dataframe
data <- data.frame(GenotypeState = genotype_states, Phenotype = phenotype_values)

# Add some noise for clarity
data$GenotypeState <- jitter(data$GenotypeState)

# Open a PNG graphics device for saving the plot
png("genotype_phenotype_plot.png", width = 6, height = 4, units = "in", res = 300)

# Create the scatter plot
ggplot(data, aes(x = GenotypeState, y = Phenotype)) +
  geom_point() +  # Add points
  geom_smooth(method = "lm", se = FALSE, color = "red", linetype = "dotted") + # Add a linear trend line
  scale_x_continuous(breaks=c(0, 1, 2)) + # Set x-axis breaks to only show 0, 1, and 2
  scale_y_continuous(breaks=c(0, 1, 2), labels=c("μ - a", "μ", "μ + a")) +
  xlab("Genotype State") +
  ylab("Phenotype (Genetic Effect + Noise)") +
  theme_minimal()

# Save the current plot
print("Saving figure")
dev.off()