# read in PM2.5 Emissions Data
unzip("exdata-data-NEI_data.zip")
NEI <- readRDS("summarySCC_PM25.rds")
PMbyYear <- tapply(NEI$Emissions,NEI$year,sum)
emission <- data.frame(year=names(PMbyYear),PMbyYear)
png(filename="plot1.png",width=480,height=480,units="px")
barplot(height=emission$PMbyYear,col="blue",xlab="Year",ylab="PM2.5(tons)",
     main="Total Pollute Emissions by Year ")
model <- line(emission$PMbyYear~emission$year)
abline(coef(model),lwd=2)
dev.off()
