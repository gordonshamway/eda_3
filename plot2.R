#download, extract and load
url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(url, dest="exdata.zip")
unzip("exdata.zip", exdir="inputfiles", list=FALSE, overwrite=TRUE, unzip="internal")
NEI <- readRDS("inputfiles/summarySCC_PM25.rds")
SCC <- readRDS("inputfiles/Source_Classification_Code.rds")

#just get Baltimore
bm <- with(NEI, fips == "24510")
bm <- NEI[bm, ]

#aggregate
bm_data <- aggregate(Emissions ~ year, data = bm, FUN = sum)

#plot it
png("plot2.png")
plot(bm_data, 
     type="l",
     main = "Total PM2.5 Emissions by Year for Baltimore",
     xlab = "Year",
     ylab = "P2.5 - Emissions [tons]")
dev.off()
