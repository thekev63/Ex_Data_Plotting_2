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

library(ggplot2)

## Question 6 - Between Baltimore City and LA which city 
## has seen greater changes over time in motor vehicle emissions?

## total for Baltimore City subsample - fips == 24510
## total for LA subsample - fips == 06037
# Searching for ON-ROAD type in NEI
NEI_Baltimore_LA_motor <- NEI[(NEI$fips=="24510"|NEI$fips=="06037") & NEI$type=="ON-ROAD",  ]

aggregatedTotalByYearAndFips <- aggregate(Emissions ~ year + fips, NEI_Baltimore_LA_motor, sum)
## add city labels to make it look nicer
aggregatedTotalByYearAndFips$fips[aggregatedTotalByYearAndFips$fips=="24510"] <- "Baltimore City"
aggregatedTotalByYearAndFips$fips[aggregatedTotalByYearAndFips$fips=="06037"] <- "Los Angeles"

## save plot to working directory
## open up the png device with typical 640x480 size
png("plot6.png", width=1040, height=480)
myplot <- ggplot(aggregatedTotalByYearAndFips, aes(factor(year), Emissions))
## add facet by city
myplot <- myplot + facet_grid(. ~ fips)
myplot <- myplot + geom_bar(stat="identity")  +
  xlab("year") +
  ylab(expression('Total PM'[2.5]*" Emissions")) +
  ggtitle('Total motor vehicle emissions, Baltimore City vs Los Angeles - 1999-2008')

## see it
myplot
## looks like LA changed more in absolute sense, 
## Baltimore maybe in a relative sense
## save it
print(myplot)
dev.off()
