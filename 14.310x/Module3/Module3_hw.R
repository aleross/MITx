setwd("/Users/alexross/MITx/Module3")

#Preliminaries
rm(list=ls())
library("utils")
library("tidyverse")

#Getting the data
gender_data <- as_tibble(read.csv("Gender_StatsData.csv"))

teenager_fr <- filter(gender_data, Indicator.Code == "SP.ADO.TFRT")

byincomelevel <- filter(teenager_fr, Country.Code%in%c("LIC", "MIC", "HIC", "WLD"))

plotdata_bygroupyear <- gather(byincomelevel, Year, FertilityRate, X1960:X2017) %>% select(Year, Country.Name, Country.Code, FertilityRate)

plotdata_byyear <- select(plotdata_bygroupyear, Country.Code, Year, FertilityRate) %>% spread(Country.Code, FertilityRate)

plotdata_bygroupyear <- mutate(plotdata_bygroupyear, Year=as.numeric(str_replace(Year,"X","")))

ggplot(plotdata_bygroupyear, aes(x=Year,y=FertilityRate,group=Country.Code,color=Country.Code)) + geom_line() + labs(title='Fertility Rate by Country-Income-Level over Time')

#From HW_3_18 
# Generating histdata_twoyears
histdata_twoyears <- select(teenager_fr, Country.Name, Country.Code, Indicator.Name, Indicator.Code, X1960,X2000)

histdata_twoyears <- gather(teenager_fr, Year, FertilityRate, X1960, X2000) %>%
  select(Year, Country.Name, Country.Code, FertilityRate)

histdata_twoyears <- filter(histdata_twoyears,!is.na(FertilityRate))

ggplot(histdata_twoyears, aes(x=FertilityRate)) + 
  geom_histogram(data=subset(histdata_twoyears, Year=="X1960"), 
                 color="darkred", fill="red", alpha=0.2) + 
  geom_histogram(data=subset(histdata_twoyears, Year=="X2000"), 
                 color="darkblue", fill="blue", alpha=0.2) 
ggsave("hist.png")

#Question 20
ggplot(histdata_twoyears, aes(x=FertilityRate, group=Year, color=Year, alpha=0.2)) +
  geom_histogram(aes(y=..density..)) +
  geom_density(data=subset(histdata_twoyears, Year=="X1960"), color="darkred", fill="red", alpha=0.2, bw=5)+ 
  geom_density(data=subset(histdata_twoyears, Year=="X2000"), color="darkblue", fill="blue", alpha=0.2, bw=5)

