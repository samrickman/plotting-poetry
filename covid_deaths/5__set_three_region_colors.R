library(dplyr)
library(magrittr)
library(tidyr)
library(readxl)
library(readr)


rm(list=ls())
setwd(dirname(sys.frame(1)$ofile))

deaths <- read_csv("cleaned_data/deaths_per_bed.csv")

unique(deaths$`Region name`)


south <- c("South East", "South West")
london <- c("London")
north <- c("North East", "North West", "Yorkshire and The Humber")
midlands <- c("East Midlands", "West Midlands", "East")

deaths$south_mid_north <- ""

deaths$south_mid_north[deaths$`Region name` %in% south] <- "South"
deaths$south_mid_north[deaths$`Region name` %in% north] <- "North"
deaths$south_mid_north[deaths$`Region name` %in% midlands] <- "Midlands"
deaths$south_mid_north[deaths$`Region name` %in% london] <- "London"

write_csv(deaths, "cleaned_data/deaths_per_bed.csv")

