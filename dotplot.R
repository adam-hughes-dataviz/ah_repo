library(ggplot2)
landdata <- read.csv("landdata-states.csv")
p1 <- ggplot(landdata,
             aes(x = State, 
                 y = Home.Price.Index)) +
  theme(legend.position = "top",
        axis.text = element_text(size = 6))

(p2 <- p1 + geom_point(aes(color = Date),
                      alpha = 0.5,
                      size = 1.5,
                      position = position_jitter(width = 0.25, height = 0)))