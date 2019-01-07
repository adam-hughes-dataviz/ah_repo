library(tidyverse)
setwd("C:/git/Experiment/Rgraphics/dataSets")

#every time I say 'housing' I want R to access the below .csv file
housing <- read_csv("landdata-states.csv")

#I want to only look at the first 5 headers
head(housing[1:5])

#plot a histogram withing 'housing' based on Home.Value with default bins 
hist(housing$Home.Value)

#load in ggplot2
library(ggplot2)

#construct a less basic histrogram, something that can be styled 
#aes is 'aesthetic'. This will construct a basic grid on your 'plot' output but we have not yet designated a y value
ggplot(housing, aes(x = Home.Value)) +
  geom_histogram()
#So we need to add details that we want to output a histogram. This way, the y-axis will be 'count' by nature


#Now let's have a look at two states' home values over time and produce a line chart 
#firstly, I want to plot a chart and define my x and y axes
plot(Home.Value ~ Date,
     col = factor(State), 
     data = filter(housing, State %in% c("MA", "TX")))
#I want to look in my 'State' column and populate my chart with the housing data in just Maine and Texas
#Now we can add a legend to the chart
legend("topleft",
       legend = c("MA", "TX"),
       col = c("black", "red"),
       pch =10)

#Simple: What does the legend contain, what colours does it represent
#'pch' stands for 'plot character'. Different values correspond to different labels. type ?pch and run for more

#now let's try the same thing using ggplot
#using the same logic but more easily defining our x and y axes. 
ggplot(filter(housing, State %in% c("MA", "TX")),
       aes(x=Date, 
           y=Home.Value, 
           color=State)) +
  geom_point()
#we can colour each point by State. Make sure to watch your cases when referring to data tables and use the US 'color'
#To add our points to the plot, we need the geom_point function

