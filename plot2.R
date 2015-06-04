#power <- read.table("household_power_consumption.txt",sep=";",na.strings = "?", header = TRUE)
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
#Pulling just the DateTime and Global_active_power Columns of FebPower Dataframe
FebPower <- select(FebPower,DateTime,Global_active_power)
#To create Time Series graph I will first create an msts object
#Uncomment next line if you need to install the forecast package
#install.packages("forecast")
library(forecast)
FebPower.msts <- msts(FebPower$Global_active_power, 
                      seasonal.periods = c(60,1440))
#Plotting the graph 
png(file="plot2.png")
plot(FebPower.msts, ylab = "Global Active Power (Kilowatts)",
     xlab = NULL, xaxt="n")
#Adding the required x-axis labels
axis(1,c(1,2,3),c("Thu","Fri","Sat"))
dev.off()