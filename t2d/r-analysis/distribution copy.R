library(ggplot2)
library(dplyr)
library(ggthemes)
library(gridExtra)
source("ggplot_theme_Publication.R")

# Using T1D PRS to predict T1D phenotype
score_t1d <- read.csv(file.path(getwd(), "t1d", "results", "megaprs", "bayesr.score"), header = T, sep=' ')
score_t1d$Type <- "T1D"
# Using T1D PRS to predict T2D phenotype
score_t2d <- read.csv(file.path(getwd(), "t1d", "results", "compare", "bayesr.score"), header = T, sep=' ')
score_t2d$Type <- "T2D"

score <- rbind(score_t1d, score_t2d) %>% na.omit()

plot1 <- score %>% filter(Phenotype == 1) %>%
    ggplot(aes(x = Profile_1, fill = Type)) +
    geom_density(alpha=0.5) +
    scale_fill_manual(values=c("blue", "red")) +
    labs(
        title = "Using T1D BayesR PRS model",
        subtitle = "to predict T1D and T2D phenotype",
        x = "Score", fill = "Type") +
    theme_tufte() + scale_colour_Publication()


# Using T2D PRS to predict T1D phenotype
score_t1d <- read.csv(file.path(getwd(), "t2d", "results", "compare", "bayesr.score"), header = T, sep=' ')
score_t1d$Type <- "T1D"
# Using T2D PRS to predict T2D phenotype
score_t2d <- read.csv(file.path(getwd(), "t2d", "results", "megaprs", "bayesr.score"), header = T, sep=' ')
score_t2d$Type <- "T2D"

score <- rbind(score_t1d, score_t2d) %>% na.omit()

plot2 <- score %>% filter(Phenotype == 1) %>%
    ggplot(aes(x = Profile_1, fill = Type)) +
    geom_density(alpha=0.5) +
    scale_fill_manual(values=c("blue", "red")) +
    labs(
        title = "Using T2D BayesR PRS model",
        subtitle = "to predict T1D and T2D phenotype",
        x = "Score", fill = "Type") +
    theme_tufte() + scale_colour_Publication()

# Open a PNG graphics device for saving the plot
png("t2d/figures/bayesr_distribution_compare.png", width = 6, height = 4, units = "in", res = 300)

combined_plot <- grid.arrange(plot1, plot2, nrow = 2)

# Save the current plot
print("Saving figure")
dev.off()
