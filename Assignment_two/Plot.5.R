### Data  ###

#Load required packages
library(downloader)
suppressPackageStartupMessages(library(dplyr))
library(ggplot2)



#Download and store data  into R
dataset_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download(dataset_url, dest = "data.zip", mode = "wb")
unzip("data.zip", exdir = ".")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")


#Convert to tibble format for better on-screen printing.
NEI  <- tbl_df(NEI)
SCC  <- tbl_df(SCC)


### Plot 5 ###

png('plot5.png')

NEI  %>%
  filter(fips == 24510, type == "ON-ROAD")  %>%
  select(Emissions, year)  %>%
  group_by(year) %>%
  summarize(total = sum(Emissions))  %>%
  ggplot(aes(x=as.factor(year),y=total)) +
  geom_bar(stat="identity",fill="darkorange3") +
  labs(title=expression("Total PM" [2.5]*" Motor Vehicle Emissions for Baltimore City, MD USA")) +
  labs(x="Year", y=expression("PM"[2.5]*" Emissions (tons)"))

dev.off()
