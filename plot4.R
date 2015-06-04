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
#Uncomment next line if you need to install the forecast package
#install.packages("forecast")
library(forecast)
FebPower_GAP <- msts(FebPower$Global_active_power,
                     seasonal.periods = c(60,1440))
FebPower_SM1 <- msts(FebPower$Sub_metering_1,
                     seasonal.periods = c(60,1440))
FebPower_SM2 <- msts(FebPower$Sub_metering_2,
                     seasonal.periods = c(60,1440))
FebPower_SM3 <- msts(FebPower$Sub_metering_3,
                     seasonal.periods = c(60,1440))
FebPower_Voltage <- msts(FebPower$Voltage,
                     seasonal.periods = c(60,1440))
FebPower_GRP <- msts(FebPower$Global_reactive_power,
                     seasonal.periods = c(60,1440))
png(file="plot4.png")
par(mfrow=c(2,2))
ts.plot(FebPower_GAP, gpars =list(ylab = "Global Active Power (Kilowatts)",
     xlab = NULL, xaxt="n"))
#Adding the required x-axis labels
axis(1,c(1,2,3),c("Thu","Fri","Sat"))
ts.plot(FebPower_Voltage, gpars = list(ylab ="Voltage",
                                       xlab="datetime",xaxt="n"))
axis(1,c(1,2,3),c("Thu","Fri","Sat"))
ts.plot(FebPower_SM1,FebPower_SM2,FebPower_SM3, gpars = list(
    col = c("black","red","blue"),xlab=NULL,xaxt="n",ylab="
    Energy sub metering"))
axis(1,c(1,2,3),c("Thu","Fri","Sat"))
text(2.6,35,"-- Sub_metering_1",cex=1, col = "black")
text(2.6,32,"-- Sub_metering_2",cex=1, col = "red")
text(2.6,29,"-- Sub_metering_3",cex=1, col = "blue")
ts.plot(FebPower_GRP, gpars = list(ylab="Global_reactive_power",
                                   xlab="datetime",xaxt="n"))
axis(1,c(1,2,3),c("Thu","Fri","Sat"))
dev.off()