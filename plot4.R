#download, extract and load
url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(url, dest="exdata.zip")
unzip("exdata.zip", exdir="inputfiles", list=FALSE, overwrite=TRUE, unzip="internal")
NEI <- readRDS("inputfiles/summarySCC_PM25.rds")
SCC <- readRDS("inputfiles/Source_Classification_Code.rds")

# filter the data
library(dplyr)
#just get the SCC column of the descriptions where One = External Combustion ... and coal in Level Three is used
finalfilter <- filter(SCC, SCC.Level.One == "External Combustion Boilers", SCC.Level.Three %in% grep("coal",ignore.case=T, value=T, SCC$SCC.Level.Three))
NEI_coal_combusted_filtered <- NEI[(NEI$SCC %in% finalfilter$SCC),]

# group by year
coalcombustedAggregated <- aggregate(Emissions ~ year, data = NEI_coal_combusted_filtered, FUN = sum)

# plot it
library(ggplot2)
png("plot4.png")
ggplot(coalcombustedAggregated, aes(x=year, y=Emissions)) + geom_line() +
  xlab("Year") +
  ylab("P2.5 Emissions [tons]") +
  ggtitle("Emissions from coal combustion-related sources")
dev.off()
