### Data  ###

#Load required packages
library(downloader)
suppressPackageStartupMessages(library(dplyr))
library(ggplot2)
library(ggthemes)



#Download and store data  into R
dataset_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download(dataset_url, dest = "data.zip", mode = "wb")
unzip("data.zip", exdir = ".")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")


#Convert to tibble format for better on-screen printing.
NEI  <- tbl_df(NEI)
SCC  <- tbl_df(SCC)


### Plot 3 ###

png('plot3.png',  width=540, height=480)

NEI  %>%
  filter(fips == 24510)  %>%
  select(Emissions, year, type)  %>%
  mutate(type = as.factor(type)) %>%
  group_by(year, type)  %>%
  summarise(total = sum(Emissions))  %>%
   ggplot(aes(factor(year),total,fill=type)) +
    geom_bar(stat="identity") +  theme_bw() +
    scale_fill_tableau(palette = "tableau10")  +
    guides(fill=FALSE) +
    facet_grid(.~type,scales = "free",space="free") +
    labs(x="year", y=expression("Total PM"[2.5]*" Emissions (Tons)")) + 
    labs(title=expression("PM"[2.5]*" Emissions for Baltimore City by Source Type"))

dev.off()
