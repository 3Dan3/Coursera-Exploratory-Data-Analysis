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


## Plot 2 ##
png("plot2.png", width=480, height=480)

sub.data %>%
  select(Timedate, Global_active_power)  %>%
  plot( type="l", xlab="", ylab="Global Active Power (kilowatts)")

dev.off()