#Install packages - Ensure No. TRUE = No. packages
list.of.packages <- c("ggplot2","rgeos","tidyverse","geojsonio",
                      "RColorBrewer","rgdal","broom","viridis")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
lapply(list.of.packages, require, character.only=T)

#set working directory and read in the json file
setwd("C:/Git/Hexgram")
spdf <- geojson_read("us_states_hexgrid.geojson", what = "sp")

#reformat
spdf@data = spdf@data %>%
  mutate(google_name = gsub(" \\(United States\\)", "", google_name))

#plot it
plot(spdf)

#Fortify the data so that it can be used with ggplot2
spdf@data = spdf@data %>%
  mutate(google_name = gsub(" \\(United States\\)", "", google_name))
spdf_fortified <- tidy(spdf, region = "google_name")

#calculate the centroid of each hexagon to add the label
centers <- cbind.data.frame(data.frame(gCentroid(spdf, byid = TRUE),
                                       id = spdf@data$iso3166_2))

#Plot using ggplot
ggplot() +
  geom_polygon(data = spdf_fortified, aes( x = long, y = lat, group = group),
               fill = "skyblue", color = "white") +
  geom_text(data = centers, aes(x = x, y = y, label = id)) +
  theme_void() +
  coord_map()

#read in data for cloropleth
data <- read.table("https://raw.githubusercontent.com/holtzy/R-graph-gallery/master/DATA/State_mariage_rate.csv", header=T, sep=",", na.strings="---")

#merge geospatial and numeric data 
spdf_fortified <- spdf_fortified %>% 
  left_join(. , data, by = c("id" = "state"))

#make cloropleth map 
ggplot() +
  geom_polygon(data = spdf_fortified, aes(fill = y_2015, x = long, y = lat, group = group)) +
  scale_fill_gradient(trans = "log") +
  theme_void() +
  coord_map()

spdf_fortified$bin <- cut(spdf_fortified$y_2015, breaks = c(seq(5,10), Inf), labels = c("5-6","6-7","7-8","8-9","9-10","10+"),
                          include.lowest = T)
my_palette <- rev(magma(8))[c(-1,-8)]

ggplot() +
  geom_polygon(data = spdf_fortified,
               aes(fill = bin, x = long, y = lat, group = group),
               size = 0, alpha = 0.9) +
  geom_text(data = centers, aes(x = x, y = y, label = id),
            color = "white", size = 3, alpha = 0.6) +
  theme_void() +
  scale_fill_manual(
    values = my_palette,
    name = "Weddings per 1,000 people in 2015",
    guide = guide_legend(keyheight = unit(3, units = "mm"), 
                         keywidth = unit(12, units = "mm"),
                         label.position = "bottom",
                         title.position = "top",
                         nrow = 1)) +
  ggtitle( "A map of marriage rates, state by state" ) +
  theme(
    legend.position = c(0.5, 0.9),
    text = element_text(color = "#22211d"),
    plot.background = element_rect(fill = "#f5f5f2", color = NA), 
    panel.background = element_rect(fill = "#f5f5f2", color = NA), 
    legend.background = element_rect(fill = "#f5f5f2", color = NA),
    plot.title = element_text(size= 22, hjust=0.5, color = "#4e4d47", margin = margin(b = -0.1, t = 0.4, l = 2, unit = "cm")),
  )

  

  
  
