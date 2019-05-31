list.of.packages <- c("data.table","ggplot2","reshape2")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
lapply(list.of.packages, require, character.only=T)

#set theme 
theme_set(
  theme_minimal()
)

#set working directory
setwd("C:/git/Experiment")

#read in csv
violin <- read.csv("violin_plot.csv")

#change name of headers to exclude i~
names(violin)[1]="country"

#turn into long form by melting and reshaping as bmi_category
violin.l = melt(violin, id.vars = "country", variable.name = "bmi_category")

#draw ggplot as below 
p <- ggplot(violin.l, aes(factor(bmi_category), value)) +
  geom_violin(aes(fill = bmi_category), trim = F) +
  scale_fill_manual(values = c("#F0826D", "#BC2629", "#8F1B13")) +
  labs(x = "", y = "Prevalence of wasting, %") +
  theme(axis.title.x = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank())

#save as png
ggsave("violin.png", p4)

#save R workspace
save.image(file = "violin.plot.RData")
