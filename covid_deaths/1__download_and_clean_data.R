library(dplyr)
library(magrittr)
library(tidyr)
library(readxl)
library(readr)
library(MMWRweek)
library(rvest)
rm(list=ls())
setwd(dirname(sys.frame(1)$ofile))

# Functions to download and read in data

# Create raw data directory
if(!dir.exists("raw_data/")) dir.create("raw_data/")

download_read_in_utla_lookup <- function(url = "https://opendata.arcgis.com/datasets/3e4f4af826d343349c13fb7f0aa2a307_0.csv",
                                         destfile = "raw_data/utla_to_ltla_lookup.csv") {
  
  if (!file.exists(destfile)) {
    download.file(url = url, destfile = destfile)
  }
  
  utla_lookup = read_csv(destfile)
  
  return(utla_lookup)
  
}
# Get UTLA to LTLA data

# Download deaths data

download_deaths_data <- function(base_url = "https://www.ons.gov.uk/",
                                 url_path = "peoplepopulationandcommunity/healthandsocialcare/causesofdeath/datasets/deathregistrationsandoccurrencesbylocalauthorityandhealthboard"){
  
  
  full_url <- paste0(base_url,
                     url_path)
  
  page <- read_html(full_url)
  
  links <- page %>% 
    html_nodes("a") %>% 
    html_attr("href")
  
  filename_string <- "lahbtablesweek.+xlsx"
  latest_link <- grep(filename_string, links, ignore.case = TRUE, value = TRUE)
  
  latest_link <- paste0(base_url,
                        latest_link)
  
  # Now we need to put in the date for the filename so:
  # a. We need to make sure it is saved with the latest date.
  # b. We need to make sure we save the same week as the same date every time, 
  #    so we do not need to download the same question twice.
  
  # Get latest week
  filename <- basename(latest_link)
  
  week_num <- gsub("lahbtablesweek", "", filename) %>% 
    gsub("\\.xlsx", "", .) %>% 
    substr(1, 2) # Sometimes week num is 3 digits with final digit being revision version
  
  # Current year
  current_year = format(Sys.Date(), "%Y")
  if(current_year == "2020" | week_num == 1 ) { 
    base_date = "2020-01-05"
  } else {
    base_date = "2021-01-05"
  }
  
  date_for_filename = as.Date(base_date) + as.integer(week_num) * 7
  
  destfile <- paste0("raw_data/",
                     date_for_filename,
                     "_deaths.xlsx")
  
  if(!file.exists(destfile)) {
    message("Downloading deaths data...")
    download.file(url = latest_link,
                  destfile = destfile,
                  mode = "wb")
  } else {
    message("Most recent deaths data already downloaded.")
  }
}


get_most_recent_deaths_file <- function(directory = "raw_data/") {

  # Files with format dd-mm-yyyy_deaths.xlsx
  files = dir(directory, 
              pattern = "\\d{4}-\\d{2}-\\d{2}_deaths\\.xlsx" 
  )
  # Reverse and most recent one will be files[1]
  files <- rev(files)
  #file_dates <- as.Date(substr(files, 1, 10), "%Y%m%d")
  full_path = paste0(directory, files[1])
  
  message("Reading in ", files[1])
  
  df = read_excel(full_path, 
                  sheet = "Occurrences - All data", 
                  skip = 3)
  
  return(df)
}

filter_to_england <- function(deaths) {
  # Remove Wales
  england_rows = grep("^E\\d.+", deaths$`Area code`) # search by E code
  deaths = deaths[england_rows,]
  
  return(deaths)
}

add_date <- function(deaths) {
  # Get the date from week ending -  MMWRday = 6 because the weeks end on a Friday
  deaths$week_ending = MMWRweek2Date(MMWRyear = rep(2020, length(deaths$`Week number`)),
                                     MMWRweek = deaths$`Week number`,
                                     MMWRday = 6)  
  return(deaths)
}

add_utla <- function(deaths, utla_lookup) {
  
  # OK so we should have 314 LLTAs
  NUMBER_OF_LTLAs = 314
  stopifnot(
    length(unique(deaths$`Area code`))==NUMBER_OF_LTLAs
  )
  
  
  # Check all LTLA can be mapped to UTLA - Buckinghamshire is missing
  sum(deaths$`Area code` %in% utla_lookup$LTLA19CD) # not all
  
  stopifnot(
    deaths$`Area name`[!(deaths$`Area code` %in% utla_lookup$LTLA19CD)]=="Buckinghamshire"  
  )
  
  # UTLA19CD is E10000002 - we'll add manually
  utla_lookup <- utla_lookup %>% 
    select(-FID) %>% 
    rename("Area code" = LTLA19CD)
  
  deaths <- left_join(deaths, utla_lookup, by = "Area code")
  
  deaths$UTLA19NM[is.na(deaths$UTLA19CD)] <- "Buckinghamshire"
  deaths$UTLA19CD[is.na(deaths$UTLA19CD)] <- "E10000002"
  
  return(deaths)
}

# Add region

add_region <- function(deaths,
                       regions_lookup) {
  
  LAs_to_drop <- c(
    "Isles of Scilly",
    "City of London"
  )
  
  deaths <- deaths %>% 
    filter(!UTLA19NM %in% LAs_to_drop)
  
  # Make sure all UTLAs match
  stopifnot(
    deaths$UTLA19NM %in% regions_lookup$`LA name`
  )
  
  deaths <- deaths %>% 
    rename(`LA name` = UTLA19NM)
  
  deaths <- inner_join(deaths, regions_lookup, by = "LA name")
  
}

# Read in data
download_deaths_data()
utla_lookup <- download_read_in_utla_lookup()
deaths <- get_most_recent_deaths_file()
regions_lookup <- read_csv("raw_data/regions_lookup.csv") # ADASS defined rather than ONS regions



deaths <- deaths %>% 
  filter_to_england() %>% 
  add_date() %>% 
  add_utla(utla_lookup = utla_lookup) %>% 
  add_region(regions_lookup = regions_lookup)

deaths_covid_care_home <- deaths %>% 
  filter(`Cause of death`=="COVID 19",
         `Place of death`=="Care home")

out_dir <- "cleaned_data/"
out_file <- paste0(out_dir,
                   Sys.Date(),
                   "_cleaned_deaths.csv")

if(!dir.exists(out_dir)) dir.create(out_dir)


write_csv(deaths_covid_care_home,
          out_file)

deaths_covid_not_care_home <-  deaths %>% 
  filter(`Cause of death`=="COVID 19",
         `Place of death`!="Care home")

out_dir <- "cleaned_data/"
out_file <- paste0(out_dir,
                   Sys.Date(),
                   "_cleaned_deaths_not_care_home.csv")

if(!dir.exists(out_dir)) dir.create(out_dir)


write_csv(deaths_covid_not_care_home,
          out_file)
