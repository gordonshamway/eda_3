#download, extract and load
url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(url, dest="exdata.zip")
unzip("exdata.zip", exdir="inputfiles", list=FALSE, overwrite=TRUE, unzip="internal")
NEI <- readRDS("inputfiles/summarySCC_PM25.rds")
SCC <- readRDS("inputfiles/Source_Classification_Code.rds")

#aggregate the data
png("plot1.png")

# aggregate it
data <- aggregate(Emissions ~ year, data = NEI, FUN = sum)

#plot it
png("plot1.png")
plot(data, 
     type="l",
     main = "Total PM2.5 Emissions by Year",
     xlab = "Year",
     ylab = "P2.5 - Emissions [tons]")
dev.off()
