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

## total for Baltimore City subsample - fips == 24510
NEI_Baltimore = NEI[which(NEI$fips=="24510"),]
totals_Baltimore = aggregate(Emissions ~ year, NEI_Baltimore, sum)

## Question @ - have total emissions for Balitmore City decreased?
barplot(totals_Baltimore$Emission, 
        main="Total Emissions By Year (Balitmore City)", 
        names.arg = totals_Baltimore$year)
## more or less the trend seems to be down
## save plot to working directory
dev.copy(png, 'plot2.png')
dev.off()

