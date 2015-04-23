library("ggplot2")
unzip("exdata-data-NEI_data.zip")
NEI <- readRDS("summarySCC_PM25.rds")
Baltimore <- NEI[NEI$fips=="24510",]
Baltimore$type <- as.factor(Baltimore$type)
emission <- c()

# Calculte the total emission for one source time per round
for(item in levels(Baltimore$type)) {
    target <- Baltimore[Baltimore$type==item,]
    PMbyYear <- tapply(target$Emissions,target$year,sum) 
    year <- names(PMbyYear)
    stype <- rep(item,dim(PMbyYear))
    temp <- cbind(PMbyYear,year,stype)
    emission <- rbind(emission,temp)
}

emission <- as.data.frame(emission,stringsAsFactors=FALSE)
emission$year <- as.Date(emission$year,"%Y")
emission$PMbyYear <- as.numeric(emission$PMbyYear)

# plot
png(filename="plot3.png",width=480,height=480,units="px")
g <- ggplot(emission,aes(year,PMbyYear)) + geom_point(aes(color=stype)) +
    geom_smooth(method="lm") + facet_grid(.~stype) +
    labs(title="Pollute Emissions by Year for Baltimore ")
print(g)
dev.off()
