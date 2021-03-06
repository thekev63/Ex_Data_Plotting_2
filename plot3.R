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

# Question 3 - Which types have seen increases in emissions in Baltimore City? 
library(ggplot2)

## save plot to working directory
## open up the png device with typical 640x480 size
png("plot3.png", width=640, height=480)
myplot <- ggplot(totals_Baltimore, aes(year, Emissions, color = type))
myplot <- myplot + geom_line() +
  xlab("year") +
  ylab(expression('Total PM'[2.5]*" Emissions")) +
  ggtitle('Total Emissions in Baltimore City - 1999 to 2008')
## see it
myplot
## point emissions were up, then down, otherwise down
## save it
print(myplot)
dev.off()

