## remember to set your working direction somewhere appropriate
## download the data
finalDest <- "exdata-data-NEI_data"
dwnldFile <- "exdata-data-NEI_data.zip"
if(!file.exists(dwnldFile)) {
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", dwnldFile)
}
file <- unzip(dwnldFile, exdir =  finalDest, overwrite = TRUE)
unlink(dwnldFile)

## cleanup
rm(list=ls())

if(exists("NEI"))
  rm("NEI")

if(exists("SCC"))
  rm("SCC")

## read the data
## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("./exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("./exdata-data-NEI_data/Source_Classification_Code.rds")
## totals US
totals_US = aggregate(Emissions ~ year, NEI, sum)
## another variation - TODO - figure out how to assign columns
## totals_US = aggregate(NEI$Emissions, by = list(NEI$year), FUN = "sum")

## question 1 - Have total emissions decreased in US from 1999 to 2008?
barplot(totals_US$Emissions, 
        main="Total Emissions By Year", 
        names.arg = totals_US$year)
## sure looks that way
## save plot to working directory
dev.copy(png, 'plot1.png')
dev.off()
