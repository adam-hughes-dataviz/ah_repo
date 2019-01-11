setwd("C:/git/ridge_plot_wd")
library(tidyverse)
library(ggridges)
library(scales)

probly <- read.csv("probly.csv", stringsAsFactors = FALSE)
probly <- gather(probly, "variable", "value", 1:17)
probly$variable <- gsub("[.]"," ", probly$variable)
probly$value <- probly$value/100

probly$variable <- factor(probly$variable,
                          c("Chances Are Slight",
                            "Highly Unlikely",
                            "Almost No Chance",
                            "Little Chance",
                            "Probably Not",
                            "Unlikely",
                            "Improbable",
                            "We Doubt",
                            "About Even",
                            "Better Than Even",
                            "Probably",
                            "We Believe",
                            "Likely",
                            "Probable",
                            "Very Good Chance",
                            "Highly Likely",
                            "Almost Certainly"))
source("ztheme.R")

ggplot(probly, aes(variable, value)) +
  geom_boxplot(aes(fill = variable), alpha = 0.5) +
  geom_jitter(aes(color = variable), size = 3, alpha = 0.2) +
  scale_y_continuous(breaks = seq(0, 1, 0.1), labels = scales::percent) +
  guides(fill = FALSE, color = FALSE) +
  labs(title = "Perceptions of Probability", 
       x = "Phrase", 
       y = "Assigned Probability") +
  coord_flip() +
  z_theme()
