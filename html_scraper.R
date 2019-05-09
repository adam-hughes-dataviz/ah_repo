list.of.packages <- c("data.table","scrapeR")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
lapply(list.of.packages, require, character.only=T)

setwd("S:/Projects/DII/Active/MQSUN - PATH partnership 2016-20/Path Management 2019/Analysing DFID's Funding for nutrition 2017/Project Content/Data")

codelist <- read.csv("MASTER_CSV.csv")
#Ensure codes don't start with 0 as will drop leading 0s

newcodes = subset(codelist, DFID.project.title=="")
#Take just the unique code as it is repetitious 
unique.newcodes = unique(newcodes$DFID.project.number)

#set the base url
base.url = "https://devtracker.dfid.gov.uk/projects/GB-1-"
#Initialise empty list to store data from loop
datalist = list()
#Starting at index 1 - As logical as it seems
data.index = 1

#New loop begin
#
for (unique.newcode in unique.newcodes) {
  message(unique.newcode)
  unique.url = paste0(base.url, unique.newcode)
  
  # Here's the magic bit. This navigates to the URL and returns to you the elements of the page
  source = scrape(unique.url, headers=T,follow=T,parse=T)[[1]]
  #Tell scraper as if we are a browser
  #Follow: Website doesn't live there - follow redirects
  #parse: Scrape data and return
  
  # Using a syntax called "xPath" we extract all the script elements
  # These are where the data is encoded
  h1_elems = getNodeSet(source,"//h1") #Get set of elements that match <h1> <header1>
  h1_vals = sapply(h1_elems,xmlValue)
  project.title = trimws(h1_vals)[1]
  project.code = paste0("GB-1-", unique.newcode) #Adding CONCAT.
  datalist[[data.index]] = data.frame(DFID.Project.Number = unique.newcode, project.code, project.title) 
  
  data.index = data.index + 1 #Run through +1 from where you were before
}

#Loop ends 

results = rbindlist(datalist)
results$full.project.title = paste0(results$project.title, " [",results$project.code,"]")

fwrite(results, "master.results.csv")

