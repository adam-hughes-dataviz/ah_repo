#Install packages - Ensure No. TRUE = No. packages
list.of.packages <- c("maptools","cartogram","tidyverse","dplyr",
                      "broom","raster","tmap","plyr","rgeos","viridis")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
lapply(list.of.packages, require, character.only=T)

#Set working directory#
setwd("C:/Git/Cartogram")

#read in data#
overweight_data <- read.csv("JME Overweight_AH.csv")
#create a subset called 'overweight df' 
#Look in 'overweight_data' as specified above
#Select everything that is " Latest " under the column head "Latest.Estimate
#Exclude! everything that has " CFSVA " under "Short.Source" head
overweight_df <- subset(overweight_data, Latest.Estimate==" Latest " & Short.Source!=" CFSVA ")
#overweight_df is now a new dataset which can be viewed
overweight_df <- overweight_df[,c("ISO","National")]
#Now it's narrowed down to just two variables 
overweight_df <- overweight_df[-c(1),]

#Rename the column headings
names(overweight_df)[1]="ISO3"
names(overweight_df)[2]="overweight"

#can't figure out why this needs to be done??
overweight_df$overweight_sqr=overweight_df$overweight^1
#Ensure values are numeric under the column overweight in overweight_df
overweight_df$overweight=as.numeric(as.character(overweight_df$overweight))
#Assigning some red values for styling later on
reds = c("#FBD7CB","#F6B2A7","#F28E83","#ED695E","#E8443A")

#Loading in the data used to compile the cartogram 
data("wrld_simpl")

#Merging the ISO3 asignations in the wrld_simpl dataset with overweight_df
wrld_simpl=merge(wrld_simpl,overweight_df,by="ISO3")
#Grabbing the 'Africa' spatial polygons
afr=wrld_simpl[wrld_simpl$REGION==2,]
#spTransform object (afr) with the Coordinate Reference System of+init
afr <- spTransform(afr, CRS("+init=epsg:3395"))

#Construct a continuous area cartogram by a rubber sheet distortion algorithm 
afr_cont <- cartogram_cont(afr,"overweight_sqr", itermax = 50)

#Style creation#
DI_style <- structure(
  list(
    bg.color = c(fill = "white", borders = "black",
                 symbols = "grey80", dots = "grey80",
                 lines = "black", text = "black", 
                 na = "grey30", null = "grey15"),
    aes.palette = list(seq = c("#FBD7CB","#F6B2A7","#F28E83","#ED695E","#E8443A"), div = "PiYG", cat = "Dark2"),
    attr.color = "Black", 
    panel.label.color = "Black",
    panel.label.bg.color = "Black",
    main.title.color = "Black"
  ),
  style = "DI"
)

#Load style and plot
tmap_options(DI_style)
tm_shape(afr_cont) +
  tm_polygons("overweight_sqr", style = "jenks") +
  tm_layout(frame = F)

#Adam Hughes dataviz#