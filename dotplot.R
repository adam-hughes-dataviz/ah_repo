setwd("C:/git/Experiment/Rgraphics/dataSets")

#Load in ggplot
library(ggplot2)

#Read .csv
landdata <- read.csv("landdata-states.csv")

#define p1, adding x and y variables, a theme and a size for the non-data sections of the chart
p1 <- ggplot(landdata,
             aes(x = State, 
                 y = Home.Price.Index)) +
  theme(legend.position = "top",
        axis.text = element_text(size = 6))

#add the stylinh for the geom_points: alpha (transparency), size and position
p2 <- p1 + geom_point(aes(color = Date),
                      alpha = 0.5,
                      size = 1.5,
                      position = position_jitter(width = 0.25, height = 0))
#try deleting the position = position_jitter to discover its importance 

#Now we can change the x-axis name and scale the key in three discrete intervals while keeping the colours continuous
p2 + scale_x_discrete(name="State Abbreviation") +
  scale_color_continuous(name="",
                         breaks = c(1976, 1994, 2013),
                         labels = c("76","94","13"),
                         low = "blue", high = "red")
#We can use 'low' and 'high' colour values to customise the gradient of coloration. Remember to keep this continuous 



