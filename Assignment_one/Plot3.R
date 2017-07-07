# Load PackageS
suppressPackageStartupMessages(library(dplyr))
library(lubridate, warn.conflicts = FALSE)

# Download and store data
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






## Plot3 ##

png("plot3.png", width=480, height=480)

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


legend("topright", lty= 1, col = c("Black", "red", "blue"), 
       legend = c( "Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

dev.off()