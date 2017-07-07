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


#Filter/subset the SCC dataframe keeping only the rows containing "Coal" and convert the
# Short.Name vector to character(from factor).
SCC.sub <- SCC  %>%
  filter(grepl("Coal", Short.Name, ignore.case=TRUE)) %>%
  mutate(Short.Name = as.character(Short.Name))

NEI <- NEI  %>%
  mutate(SCC = as.factor(SCC))


### Plot 4 ###

png('plot4.png',  width=480, height=480)

#Join the two dataframes by 'SCC' + Plot
semi_join(NEI, SCC.sub)  %>%
  select(year, Emissions) %>%
  group_by(year) %>%
  summarize(total = sum(Emissions/10^6))  %>%
  ggplot(aes(x=as.factor(year),y=total)) +
  geom_bar(stat="identity",fill= "brown") +
  labs(title=expression("U.S. Coal Combustion-Related PM" [2.5]* " Emissions")) + 
  labs(x="Year", y=expression("PM" [2.5]* " Emissions (Millions of Tons)"))

dev.off()
