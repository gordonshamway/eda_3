#download, extract and load
url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(url, dest="exdata.zip")
unzip("exdata.zip", exdir="inputfiles", list=FALSE, overwrite=TRUE, unzip="internal")
NEI <- readRDS("inputfiles/summarySCC_PM25.rds")
SCC <- readRDS("inputfiles/Source_Classification_Code.rds")

#just get Baltimore
bm <- with(NEI, fips == "24510")
bm <- NEI[bm, ]

#filter the data
library(dplyr)
filter5 <- filter(SCC, SCC.Level.One == "Mobile Sources", SCC.Level.Two == "Highway Vehicles - Gasoline")
bm.filtered <- bm[(bm$SCC %in% filter5$SCC),]

#aggregate it
bm.aggregated <- aggregate(Emissions ~ year, data = bm.filtered, FUN = sum)

#plot it 
library(ggplot2)
png("plot5.png")
ggplot(bm.aggregated, aes(x=year, y=Emissions)) + geom_line() +
  ggtitle("Emissions from motor vehicle sources")
dev.off()
