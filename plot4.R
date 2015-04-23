unzip("exdata-data-NEI_data.zip")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# find pollution source which is coal combustion-related
coal <- grep("[Cc]oal",SCC$Short.Name)
pCoal <- SCC[coal,1]

# subset those coal combuston-related
dataCoal <- subset(NEI,(SCC %in% pCoal))

# calculate the emission by these source per year
PMbyYear <- tapply(dataCoal$Emissions,dataCoal$year,sum)
year <- names(PMbyYear)
emission <- as.data.frame(cbind(PMbyYear,year),stringsAsFactors=FALSE)
emission$year <- as.Date(emission$year,"%Y")
emission$PMbyYear <- as.numeric(emission$PMbyYear)

# plot
png(filename="plot4.png",width=480,height=480,units="px")
plot(x=emission$year,y=emission$PMbyYear,col="blue",pch=16,xlab="Year",ylab="PM2.5(tons)",
     main="Coal Pollute Emissions by Year ")
model <- line(emission$PMbyYear~emission$year)
abline(coef(model),lwd=2)
dev.off()
