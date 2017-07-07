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


### Plot 6 ###

png('plot6.png')

NEI  %>%
  filter(fips %in% c("24510", "06037"), type == "ON-ROAD")  %>%
  mutate(city = factor(fips, labels = c("Los Angeles", "Baltimore "))) %>%
  select(Emissions, year, city)  %>%
  mutate(city = as.factor(city))  %>%
  group_by(year, city) %>%
  summarize(total = sum(Emissions))  %>%  
  ggplot(aes(factor(year),total,fill=city)) +
  scale_fill_brewer(palette = "Set1")    +
  geom_bar(stat="identity") +  
  guides(fill=FALSE) +
  facet_grid(.~city, scales = "free",space="free") + 
  labs(x="year", y=expression("Total PM"[2.5]*" Emission (Tons)")) + 
  ggtitle("Motor Vehicle Emissions in Los Angeles County  \nvs. Baltimore City") 

dev.off()
