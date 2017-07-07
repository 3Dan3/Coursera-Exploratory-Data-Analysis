## Load PackageS
suppressPackageStartupMessages(library(dplyr))
library(lubridate, warn.conflicts = FALSE)

## Download and store data
if(!file.exists("EDA-data-household_power_consumption.zip")) {
  temp <- tempfile()
  download.file("http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)
  file <- unzip(temp)
  unlink(temp)
}

# Read Data into R
data <- read.table(file, header=TRUE, sep=";", stringsAsFactors=FALSE, dec=".")


#Subset time range + Convert to numeric
sub.data <-  data  %>%
  filter(Date %in%  c("1/2/2007", "2/2/2007"))  %>%
  mutate(Timedate = parse_date_time(paste(Date, Time),"%d/%m/%Y %H:%M:%S"))  %>%
  select(Timedate, Voltage, contains("Global"), contains("Sub"))   %>%
  mutate_each(funs(as.numeric), -Timedate)

## Plot 4 ##
png("plot4.png", width=480, height=480)

#Sets graphing parameters so that 4 graphs are displayed by column
par(mfcol = c(2,2))

#Creates first graph in column 1
sub.data %>%
  select(Timedate, Global_active_power)  %>%
  plot( type="l", xlab="", ylab="Global Active Power (kilowatts)")

#Creates 2nd graph in column 1 
sub.data   %>%
  select(Timedate, Sub_metering_1)  %>%
  plot(type = "l", xlab = "", ylab = "Energy sub metering")  %>%
  lines()

sub.data  %>%
  select(Timedate, Sub_metering_2)  %>%
  lines(type = "l", col = "red")

sub.data  %>%  
  select(Timedate, Sub_metering_3)  %>%
  lines(type = "l", col = "blue")


###To fix the legend in the plot so that it reproduces exactly plot #4 in the assignment, I set bty = n to remove the box, and cex = 0.9 to shrink the text.

legend("topright", col=c("black","red","blue"), c("Sub_metering_1  ","Sub_metering_2  ", "Sub_metering_3  "),lty=c(1,1), bty="n", cex=.9)



#Creates first graph in column 2, datetime vs Voltage
sub.data  %>%
  select(Timedate, Voltage)  %>%
  plot(type = "l", xlab = "datetime", ylab = "Voltage")

#Creates second graph in column 2, datetime v Global reactive power
sub.data  %>%
  select(Timedate, Global_reactive_power)  %>%
  plot(type = "l", xlab = "datetime", ylab = "Global_reactive_power")



dev.off()
