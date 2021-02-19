
library(dplyr)
library(magrittr)
library(readr)
library(tidyr)
library(ggplot2)
library(plotly)
library(ggthemes)
library(scales)
library(readr)
library(RColorBrewer)

rm(list=ls())

#setwd(dirname(rstudioapi::getSourceEditorContext()$path))

# Load deaths data
deaths <- read_csv("cleaned_data/deaths_per_bed.csv")

download_file <- function(url, destfile) {
  
  if(file.exists(destfile)) {
    message("File already downloaded!")
    return()
  }
  
  message("Downloading file...")
  download.file(url = url,
                destfile = destfile)
  message("File saved to: ", destfile)
  
}

# From http://opencouncildata.co.uk/downloads.php

url = "http://opencouncildata.co.uk/csv1.php"
destfile = "raw_data/council_data.csv"

download_file(url = url,
              destfile = destfile)

politics = read_csv(destfile)


# Bristol, Kingston, County Durham, Herefordshire and Buckinghameshire do not
# match by name
unique(deaths$`Area name`[!deaths$`Area name` %in% politics$name])

deaths$`Area name` = gsub(", City of", "", deaths$`Area name`)
deaths$`Area name` = gsub(", County of", "", deaths$`Area name`)
deaths$`Area name`[deaths$`Area name`=="County Durham"] = "Durham"
deaths$`Area name`[deaths$`Area name`=="Buckinghamshire"] = "Buckinghamshire CC"

# They should all match now
stopifnot(
  deaths$`Area name` %in% politics$name
)
# clean names
names(politics) = paste0("pol_", gsub("\\s+", "", names(politics)))

deaths_pol = inner_join(deaths, politics, by = c("Area name" = "pol_name"))

# Check they all matched
stopifnot(
  nrow(deaths_pol)==nrow(deaths)
)

deaths_pol_most_recent = deaths_pol  %>% 
filter(week_ending == max(week_ending))

ggplot(data = deaths_pol_most_recent,
  mapping = aes(
    x = pol_lab,
    y = deaths_per_1k_beds
  )) + 
  geom_point(aes(color = pol_majority))

ggplot(data = deaths_pol_most_recent,
  mapping = aes(
    x = pol_lab,
    y = deaths_per_1k_beds
  )) + 
  geom_point(aes(color = pol_majority),
  size = 5) +
   geom_smooth(method='lm', color = "#136927", size = 2) +
   ggtitle("Covid-19: local authority care home mortality rate by political control") + 
   xlab("Number of Labour councillors") +
   ylab("Deaths per 1,000 beds") +
   theme_stata() + 
   theme(legend.title = element_text()) + 
   scale_color_manual(values = c("blue", "pink", "red", "#f5ce42", "purple")) +
   guides(color=guide_legend(title = "Overall control")) +
   stat_cor(method = "pearson", label.x = 74, label.y = 74, angle=10, color="#136927") 


   ggsave("plots/suggestio_falsi.png",
     width = 12.8*2,
  height = 7.2*2,
  units = "cm")

