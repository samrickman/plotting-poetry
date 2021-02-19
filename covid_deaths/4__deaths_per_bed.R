library(dplyr)
library(magrittr)
library(tidyr)
library(readxl)
library(readr)


rm(list=ls())
setwd(dirname(sys.frame(1)$ofile))


load_cleaned_deaths <- function(directory = "cleaned_data/",
                                pattern = "\\d{4}-\\d{2}-\\d{2}_deaths_imd_pop\\.csv") {
  
  # Files with format dd-mm-yyyy_deaths_imd_pop.csv
  files = dir(directory, 
              pattern = pattern 
  )
  # Reverse and most recent one will be files[1]
  files <- rev(files)
  #file_dates <- as.Date(substr(files, 1, 10), "%Y%m%d")
  full_path = paste0(directory, files[1])
  
  message("Reading in ", files[1])
  
  df = read_csv(full_path)
  
  return(df)
}

calculate_deaths_per_bed <- function(deaths,
                                     beds) {
  
  
  # Assert we can match all by code
  stopifnot(
    deaths$`Area code` %in% beds$lad_code_2020
  )
  
  deaths <- inner_join(deaths,
                       beds,
                       by = c("Area code" = "lad_code_2020"))
  
  
  FIRST_RECORDED_COVID_DEATH = as.Date("2020-03-06")
  
  deaths <- deaths %>% 
    #filter(week_ending >= FIRST_RECORDED_COVID_DEATH) %>% 
    arrange(`Week number`) %>% 
    group_by(`Area code`, `LA name`, `total_beds_ltla`) %>% 
    mutate(
      cumulative_deaths_care_home = cumsum(`Number of deaths`),
      deaths_per_1k_beds = cumulative_deaths_care_home / total_beds_ltla * 1000
    )     
  
  return(deaths)
}

deaths <- load_cleaned_deaths()
beds <- read_csv("cleaned_data/beds_per_ltla.csv")
deaths_not_care_home <- load_cleaned_deaths(pattern = "\\d{4}-\\d{2}-\\d{2}_cleaned_deaths_not_care_home\\.csv")

deaths <- calculate_deaths_per_bed(deaths = deaths,
                                   beds = beds)


FIRST_RECORDED_COVID_DEATH = as.Date("2020-03-06")

deaths_not_care_home <- deaths_not_care_home %>% 
  #filter(week_ending >= FIRST_RECORDED_COVID_DEATH) %>% 
  arrange(`Week number`) %>% 
  group_by(`Area code`, `Week number`) %>% 
  summarise(
    num_deaths_gen_pop = sum(`Number of deaths`),
    .groups = "drop"
  ) %>% 
  group_by(`Area code`) %>% 
  mutate(
    cumulative_deaths_gen_pop = cumsum(num_deaths_gen_pop)
  ) 

deaths <- inner_join(deaths,
                     deaths_not_care_home,
                     by = c("Area code",
                            "Week number")) %>% 
  mutate(death_rate_per_1k_over_65_gen_pop = cumulative_deaths_gen_pop / pop_over_65_2020 * 1000,
         death_rate_per_1k_over_all_gen_pop = cumulative_deaths_gen_pop / pop_all_ages_2020 * 1000)

deaths$Deprivation <- Hmisc::cut2(deaths$imd_score, g = 3)

levels(deaths$Deprivation)[1] <- "Low"
levels(deaths$Deprivation)[2] <- "Medium"
levels(deaths$Deprivation)[3] <- "High"

# deaths$imd_quartile <- Hmisc::cut2(deaths$imd_score, g = 4)
# deaths$imd_quintile <- Hmisc::cut2(deaths$imd_score, g = 5)
# deaths$imd_sextile <- Hmisc::cut2(deaths$imd_score, g = 6)
# deaths$imd_septile <- Hmisc::cut2(deaths$imd_score, g = 7)


write_csv(deaths,
          "cleaned_data/deaths_per_bed.csv")

