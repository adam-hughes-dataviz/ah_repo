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
       pch = 1)

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

#The below plot is a scatter chart which filters our data 'housing' with Date == (exactly equal) to 2001.25
#hp2001Q1 just stands for 'house prices in 2001 Quater 1 (hence the 0.25 in the date)
#we have defined our x and y aces as land value and structure cost respectively 
#added geom_point to populate the data frame 
hp2001Q1 <- filter(housing, Date== 2001.25)
ggplot(hp2001Q1,
       aes(y = Structure.Cost, x = Land.Value)) +
  geom_point()

#you can also create non-linear axes such as log normal 
#As you can see (when compared to the above), the order of the x and y axes do not matter
ggplot(hp2001Q1,
       aes(x = log(Land.Value), y = Structure.Cost)) +
  geom_point()

#The plot can also contain a line-of-best-fit
#Pred.SC is in our data table. Click on hp2001Q1 in the environment to view it in a new tab above
hp2001Q1$pred.SC <- predict(lm(Structure.Cost ~ log(Land.Value), data = hp2001Q1))

#p1 is assigned the value of the log normal ggplot with the below x and y axes
p1 <- ggplot(hp2001Q1, aes(x = log(Land.Value), y = Structure.Cost))
#Now we can add a gradiented colour with respect to Home.Value 
p1 + geom_point(aes(color = Home.Value)) +
  geom_line(aes(y = pred.SC))
#geom_line based on pred.SC will be added too

#Alternatively, we can use a non-liner line-of-best-fit 
p1 + 
  geom_point(aes(color = Home.Value)) +
  geom_smooth()

#If we want to add labels, we can use geom_text
p1 +
  geom_text(aes(label = State), size=3)
#We can choose to not assign a size but the default label size is a bit big so we designate size = 3

#Sometimes, text overlaps the geom_points. We need to use ggrepel to counteract this
library(ggrepel)
#Now we can add this to geom_text
p1 +
  geom_point() +
  geom_text_repel(aes(label=State), size=3)
#We've already pre-defined p1 to have a logarithmic scale so we don't need to reconstruct the chart area

#Let's try another exercise using EconomistData. This is in the same folder so no need to reset the wd
dat <- read.csv("EconomistData.csv")

#We can create a scatter plot with CPI and HDI as the axes
ggplot(dat, aes(x = CPI, y = HDI)) +
  geom_point(color = "blue")
#When using colours, we use the American 'color'. "blue" is known to the programme but it needs to be in " " 
#When colouring by something else, like Region for example, we don't use " ". For example...
ggplot(dat, aes(x = CPI, y = HDI)) +
  geom_point(aes(color = Region), size = 2)
#We want to make the dots a bit bigger so add a size aesthetic

#If we want to adjust the size of the bubbles to weight by HDI Rank, we can 
ggplot(dat, aes(x = CPI, y = HDI)) +
  geom_point(aes(color = Region), size = HDI.Rank)

#Going back to our original chart...
ggplot(dat, aes(x = CPI, y = HDI)) +
  geom_point() +
  geom_smooth()
#we can see here that geom_smooth adds smoothers
#We want them to use a linear model however...
ggplot(dat, aes(x = CPI, y = HDI)) +
  geom_point() +
  geom_smooth(method = "lm")

#back to the housing. The below chart is a dotplot showing the distribtuion of house prices by date and state
#Start in by redefining 'dat' as the correct .csv (this may involve clearing your environment)
landdata <- read.csv("landdata-states.csv")

#We want to access dat, aesthetically define z and y and add a 'theme'. The theme we add defines the legend position 
#
p2 <- ggplot(landdata,
             aes(x = State, 
                 y = Home.Price.Index)) +
  theme(legend.position = "top",
        axis.text = element_text(size = 6))

#axis.text = element_text is just to add a size to the non-data points on the chart (x and y-axis labels, e.g.)

#We will now colour by date and define an alpha (transparency) and dot size. 
p3 <- p2 + geom_point(aes(color = Date),
                      alpha = 0.5,
                      size = 1.5,
                      position = position_jitter(width = 0.25, height = 0))
#position jitter adds direction and controls the dots. Try deleting the line above to see what it does. 
#The above is just assigning p4. You will have to type p4 and run it for the plot to appear on the right

p3
