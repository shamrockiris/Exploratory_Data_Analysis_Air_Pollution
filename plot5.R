unzip("exdata-data-NEI_data.zip")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# find pollution source which caused by motor vehicle
motor <- c(grep("[Mm]otor [Vv]ehicle",SCC$Short.Name),grep("Veh",SCC$Short.Name))
pMotor <- SCC[motor,1]

# subset motor vehicle caused pollution in Baltimore
dataMotor <- subset(NEI,(SCC %in% pMotor) & fips == "24510")

# calculate the emission by these source per year
PMbyYear <- tapply(dataMotor$Emissions,dataMotor$year,sum)

emission <- data.frame(year=names(PMbyYear),PMbyYear)


# plot
png(filename="plot5.png",width=480,height=480,units="px")
barplot(emission$PMbyYear,col="blue",xlab="Year",ylab="PM2.5(tons)",
     main="Motor Vehicle Pollution by Year ")
model <- line(emission$PMbyYear~emission$year)
abline(coef(model),lwd=2)
dev.off()

