### Data  ###

#Load required packages
library(downloader)
suppressPackageStartupMessages(library(dplyr))



#Download and store data  into R
dataset_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download(dataset_url, dest = "data.zip", mode = "wb")
unzip("data.zip", exdir = ".")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")


#Convert to tibble format for better on-screen printing.
NEI  <- tbl_df(NEI)
SCC  <- tbl_df(SCC)



### Plot 1 ###

png('plot1.png')

NEI  %>%
  select(Emissions, year)  %>%
  group_by(year)  %>%
  summarise (total=sum(Emissions)/10^6)  %>%
  select(year, total)  %>%
  with(barplot(total, names.arg = year, col = "brown", xlab="Year",
               ylab=expression("PM" [2.5]* " Emissions (Millions of Tons)"),
               main=expression("Total PM" [2.5]*" Emissions From All US Sources")) )

dev.off()
