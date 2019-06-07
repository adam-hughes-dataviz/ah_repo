list.of.packages <- c("tidyr","reshape2")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
lapply(list.of.packages, require, character.only=T)

setwd("S:/Projects/GNR/GNR 2019/Project content/Data and Analysis/Chapter analysis files/Chapter 2/GBD")
olddata_wide <- read.csv("RBind.csv")

# keep <- c("country","2019","2030")
# names(olddata_wide)[c(1,9,10)] = keep
# olddata_wide = olddata_wide[,keep]
# 
# newdata.l = melt(olddata_wide, measure.vars = c("2019","2030"), variable.name = "year")

keep <- c(1,2,5,6,9,10,13,14,17,18)
olddata_wide = olddata_wide[,keep]
names(olddata_wide)[1] = "ISO"

newdata.l = melt(olddata_wide, id.vars = c("ISO","Location"))
newdata.l$variable = as.character(newdata.l$variable)
newdata.l$variable=substr(newdata.l$variable,2,nchar(newdata.l$variable))

newdata.l = separate(newdata.l,"variable",into = c("year","var"),sep = "_")
write.csv(newdata.l, "newdata.l.csv")
