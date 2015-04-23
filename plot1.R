# read in PM2.5 Emissions Data
unzip("exdata-data-NEI_data.zip")
NEI <- readRDS("summarySCC_PM25.rds")
PMbyYear <- tapply(NEI$Emissions,NEI$year,sum)
year <- names(PMbyYear)
emission <- as.data.frame(cbind(PMbyYear,year),stringsAsFactors=FALSE)
emission$year <- as.Date(emission$year,"%Y")
emission$PMbyYear <- as.numeric(emission$PMbyYear)
png(filename="plot1.png",width=480,height=480,units="px")
plot(x=emission$year,y=emission$PMbyYear,col="blue",pch=16,xlab="Year",ylab="PM2.5(tons)",
     main="Total Pollute Emissions by Year ")
model <- line(emission$PMbyYear~emission$year)
abline(coef(model),lwd=2)
dev.off()
