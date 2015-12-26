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
totals_Baltimore = aggregate(Emissions ~ year + type, NEI_Baltimore, sum)

library(ggplot2)

## Question 4 - Across the United States, how have emissions from coal 
## combustion-related sources changed from 1999-2008?
## to answer, we need to merge the two datasets
## Note - this takes a while too
if(!exists("NEI_SCC")){
  NEI_SCC <- merge(NEI, SCC, by="SCC")
}

## fetch all records with Short.Name (SCC) Coal
coalMatches  <- grepl("coal", NEI_SCC$Short.Name, ignore.case=TRUE)
## subset those records
subsetNEI_SCC <- NEI_SCC[coalMatches, ]
## aggregate emissions by year
aggregatedTotalByYear <- aggregate(Emissions ~ year, subsetNEI_SCC, sum)

## save plot to working directory
## open up the png device with typical 640x480 size
png("plot4.png", width=640, height=480)
myplot <- ggplot(aggregatedTotalByYear, aes(factor(year), Emissions))
myplot <- myplot + geom_bar(stat="identity") +
  xlab("year") +
  ylab(expression('Total PM'[2.5]*" Emissions")) +
  ggtitle('Total Emissions from coal sources - 1999 to 2008')
## see it - why am I not seeing ?
myplot
## save it - that's OK
## looks like coal use went up slightly, then dropped significantly
print(myplot)
dev.off()

