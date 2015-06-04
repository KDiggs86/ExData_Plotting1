power <- read.table("household_power_consumption.txt",sep=";",na.strings = "?", header = TRUE)
#Uncomment next line if dply is not installed
#install.packages("dplyr")
library(dplyr)
#converting date variable to Date class
power$Date <- as.Date(power$Date,"%d/%m/%Y")
#Filter only rows from Feb 1 and 2, 2007
FebPower <- filter(power, Date == "2007-02-01" | 
                       Date == "2007-02-02")
#Creating the histogram and saving it to a png file
png(file = "plot1.png")
hist(FebPower$Global_active_power, xlab = "Global Active Power (kilowatts)", 
     col = "red", main = "Global Active Power")
dev.off()
