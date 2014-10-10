#download, extract and load
url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(url, dest="exdata.zip")
unzip("exdata.zip", exdir="inputfiles", list=FALSE, overwrite=TRUE, unzip="internal")
NEI <- readRDS("inputfiles/summarySCC_PM25.rds")
SCC <- readRDS("inputfiles/Source_Classification_Code.rds")

#construct the filter
library(dplyr)
general_filter <- filter(SCC, SCC.Level.One == "Mobile Sources", SCC.Level.Two == "Highway Vehicles - Gasoline")

#filter the data for Balitmore
bm <- with(NEI, fips == "24510")
bm <- NEI[bm, ]
bm.filtered <- bm[(bm$SCC %in% general_filter$SCC),]

#aggregate BA
bm.aggregated <- aggregate(Emissions ~ year, data = bm.filtered, FUN = sum)

#filter the data for LA
la <- with(NEI, fips == "06037")
la <- NEI[la, ]
la.filtered <- la[(la$SCC %in% general_filter$SCC),]

#aggregate LA
la.aggregated <- aggregate(Emissions ~ year, data = la.filtered, FUN = sum)

#combine the datasets for easier plotting later on
bm.aggregated$City <- "Baltimore"
la.aggregated$City <- "LA"
t <- rbind(bm.aggregated, la.aggregated)

#plot everything together 
library(ggplot2)
png("plot6.png")
qplot(year, Emissions, data=t, geom="line", color=City) +
  geom_point(size=3) +
  xlab("Year") +
  ylab("P2.5 Emissions [tons]") +
  ggtitle("P2.5 Emissions [tons] per year for Baltimore and LA")
dev.off()

