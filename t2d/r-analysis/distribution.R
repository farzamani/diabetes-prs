library(ggplot2)
library(dplyr)
library(ggthemes)
library(gridExtra)
source("ggplot_theme_Publication.R")

# Using T1D PRS to predict T1D phenotype
score_t1d <- read.csv(file.path(getwd(), "t1d", "results", "megaprs", "bayesr.score"), header = T, sep=' ')
score_t1d$Type <- "T1D"
# Using T2D PRS to predict T1D phenotype
score_t2d <- read.csv(file.path(getwd(), "t2d", "results", "compare", "bayesr.score"), header = T, sep=' ')
score_t2d$Type <- "T2D"

score <- rbind(score_t1d, score_t2d) %>% na.omit()

plot1 <- score %>% filter(Type == "T1D") %>%
    ggplot(aes(x = Profile_1, fill = factor(Phenotype))) +
    geom_density(alpha=0.5) +
    scale_fill_manual(values=c("blue", "red")) +
    labs(
        title = "Using T1D BayesR PRS model",
        subtitle = "to predict T1D phenotype",
        x = "Score", fill = "Phenotype") +
    theme_tufte() + scale_colour_Publication()
    # geom_vline(aes(xintercept=mean(Profile_1)), color="black", linetype="dashed") +
    # facet_wrap(~ Phenotype)

plot2 <- score %>% filter(Type == "T2D") %>%
    ggplot(aes(x = Profile_1, fill = factor(Phenotype))) +
    geom_density(alpha=0.5) +
    scale_fill_manual(values=c("blue", "red")) +
    labs(
        title = "Using T2D BayesR PRS model",
        subtitle = "to predict T1D phenotype",
        x = "Score", fill = "Phenotype") +
    theme_tufte() + scale_colour_Publication()

# Using T1D PRS to predict T2D phenotype
score_t1d <- read.csv(file.path(getwd(), "t1d", "results", "compare", "bayesr.score"), header = T, sep=' ')
score_t1d$Type <- "T1D"
# Using T2D PRS to predict T2D phenotype
score_t2d <- read.csv(file.path(getwd(), "t2d", "results", "megaprs", "bayesr.score"), header = T, sep=' ')
score_t2d$Type <- "T2D"

score <- rbind(score_t1d, score_t2d) %>% na.omit()

plot3 <- score %>% filter(Type == "T1D") %>%
    ggplot(aes(x = Profile_1, fill = factor(Phenotype))) +
    geom_density(alpha=0.5) +
    scale_fill_manual(values=c("blue", "red")) +
    labs(
        title = "Using T1D BayesR PRS model",
        subtitle = "to predict T2D phenotype",
        x = "Score", fill = "Phenotype") +
    theme_tufte() + scale_colour_Publication()
    # geom_vline(aes(xintercept=mean(Profile_1)), color="black", linetype="dashed") +
    # facet_wrap(~ Phenotype)

plot4 <- score %>% filter(Type == "T2D") %>%
    ggplot(aes(x = Profile_1, fill = factor(Phenotype))) +
    geom_density(alpha=0.5) +
    scale_fill_manual(values=c("blue", "red")) +
    labs(
        title = "Using T1D BayesR PRS model",
        subtitle = "to predict T2D phenotype",
        x = "Score", fill = "Phenotype") +
    theme_tufte() + scale_colour_Publication()

# Open a PNG graphics device for saving the plot
png("t2d/figures/bayesr_distribution.png", width = 6, height = 4, units = "in", res = 300)

combined_plot <- grid.arrange(plot2, plot3, nrow = 2)

# Save the current plot
print("Saving figure")
dev.off()


# less t1d/results/megaprs/bayesr/score.profile | awk '{print $1,$3,$5}' > t1d/results/megaprs/bayesr.score
# less t1d/results/compare/bayesr/score.profile | awk '{print $1,$3,$5}' > t1d/results/compare/bayesr.score
# less t2d/results/megaprs/bayesr/score.profile | awk '{print $1,$3,$5}' > t2d/results/megaprs/bayesr.score
# less t2d/results/compare/bayesr/score.profile | awk '{print $1,$3,$5}' > t2d/results/compare/bayesr.score

# Independent t-test
# t1d_0 <- score %>% filter(Type == "T1D", Phenotype == 0)
# t1d_1 <- score %>% filter(Type == "T1D", Phenotype == 1)
# t2d_0 <- score %>% filter(Type == "T2D", Phenotype == 0)
# t2d_1 <- score %>% filter(Type == "T2D", Phenotype == 1)


# t_test_result <- t.test(t1d_0$Profile_1, t1d_1$Profile_1, var.equal = TRUE)
# t_test_result

# t_test_result <- t.test(t2d_0$Profile_1, t2d_1$Profile_1, var.equal = TRUE)
# t_test_result

# t_test_result <- t.test(t1d_1$Profile_1, t2d_1$Profile_1, var.equal = TRUE)
# t_test_result

# t_test_result <- t.test(t1d_0$Profile_1, t2d_0$Profile_1, var.equal = TRUE)
# t_test_result
