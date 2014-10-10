#download, extract and load
url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(url, dest="exdata.zip")
unzip("exdata.zip", exdir="inputfiles", list=FALSE, overwrite=TRUE, unzip="internal")
NEI <- readRDS("inputfiles/summarySCC_PM25.rds")
SCC <- readRDS("inputfiles/Source_Classification_Code.rds")

#just get Baltimore
bm <- with(NEI, fips == "24510")
bm <- NEI[bm, ]

#aggregate it
bm_data <- aggregate(x=bm$Emissions, by = list(bm$year ,bm$type) ,FUN = sum)

#set nicer names
colnames(bm_data) <- c("Year", "Source_Type", "Emission")

#plot it
library(ggplot2)
png("plot3.png")
gp <- ggplot(data = bm_data, aes(x=Year, y=Emission, group=Source_Type, color=Source_Type)) +geom_line() +geom_point()
gp <- gp + xlab("Year") + ylab("P25 Emissions [tons]")
gp <- gp + ggtitle("Total Emmissions by Pollution Source and Year for Baltimore")
gp
dev.off()
