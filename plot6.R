library(ggplot2)
unzip("exdata-data-NEI_data.zip")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# find pollution source which caused by motor vehicle
motor <- c(grep("[Mm]otor [Vv]ehicle",SCC$Short.Name),grep("Veh",SCC$Short.Name))
pMotor <- SCC[motor,1]

# subset motor vehicle caused pollution in Baltimore
dataMotorBT <- subset(NEI,(SCC %in% pMotor) & fips == "24510")
# subset motor vehicle caused pollution in Los Angels
dataMotorLA <- subset(NEI,(SCC %in% pMotor) & fips == "06037")

emission = c()
# calculate the pollution in Baltimore
PMbyYear <- tapply(dataMotorBT$Emissions,dataMotorBT$year,sum)
year <- names(PMbyYear)
area = rep("Baltimore",dim(PMbyYear))
temp <- cbind(PMbyYear,year,area)
emission <- rbind(emission,temp)

# calculate the pollution in Los Angeles
PMbyYear <- tapply(dataMotorLA$Emissions,dataMotorLA$year,sum)
year <- names(PMbyYear)
area = rep("Los Angeles",dim(PMbyYear))
temp <- cbind(PMbyYear,year,area)
emission <- rbind(emission,temp)

# transform into data frame
emission <- as.data.frame(emission,stringsAsFactors=FALSE)
emission$year <- as.Date(emission$year,"%Y")
emission$PMbyYear <- as.numeric(emission$PMbyYear)
emission$area <- as.factor(emission$area)

# plot
png(filename="plot6.png",width=480,height=480,units="px")
g <- ggplot(emission,aes(year,PMbyYear)) + geom_point(aes(color=area)) +
    labs(title="Motor Vehicle Pollution Compare")
print(g)
dev.off()

