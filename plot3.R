power <- read.table("household_power_consumption.txt",sep=";",na.strings = "?", header = TRUE)
#Uncomment next line if dply is not installed
#install.packages("dplyr")
library(dplyr)
#converting date variable to Date class
power$Date <- as.Date(power$Date,"%d/%m/%Y")
#Filter only rows from Feb 1 and 2, 2007
FebPower <- filter(power, Date == "2007-02-01" | 
                       Date == "2007-02-02")
#Combining Date and Time column
DateTime <- as.POSIXct(paste(FebPower$Date,FebPower$Time),format=
                           "%Y-%m-%d %H:%M:%S")
FebPower <- cbind(DateTime,FebPower)
#Selecting only the columns that we need
FebPower <- select(FebPower, DateTime, Sub_metering_1:Sub_metering_3)
#Converting the appropriate columns to msts objects
library(forecast)
FebPower.1 <- msts(FebPower$Sub_metering_1, 
                      seasonal.periods = c(60,1440))
FebPower.2 <- msts(FebPower$Sub_metering_2, 
                   seasonal.periods = c(60,1440))
FebPower.3 <- msts(FebPower$Sub_metering_3, 
                   seasonal.periods = c(60,1440))
#Use ts.plot to create multiple time series graphs 
png(file="plot3.png")
ts.plot(FebPower.1,FebPower.2,FebPower.3, gpars = list(
    col = c("black","red","blue"),xlab=NULL,xaxt="n",ylab="
    Energy sub metering"))
axis(1,c(1,2,3),c("Thu","Fri","Sat"))
legend("topright",legend=c("Sub_metering_1","Sub_metering_2",
                          "Sub_metering_3"),
       col=c("black","red","blue"), lty=1,cex=1)
dev.off()