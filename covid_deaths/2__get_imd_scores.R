library(dplyr)
library(magrittr)
library(tidyr)
library(readxl)
library(readr)

rm(list=ls())
setwd(dirname(sys.frame(1)$ofile))

# Functions to download and read in data

load_imd_data <- function(url, destfile) {
  if(!file.exists(destfile)) {
    download.file(url = url,
                  destfile = destfile)
  }
  
  df = read_csv(destfile)
  
  # Only interested in overall IMD score
  df <- df %>% 
    select(`Local Authority District code (2019)`,
           `Local Authority District name (2019)`,
           `Index of Multiple Deprivation (IMD) Score`)
  
  return(df)
  
}

load_population_data <- function(url = "https://www.ons.gov.uk/file?uri=%2fpeoplepopulationandcommunity%2fpopulationandmigration%2fpopulationestimates%2fdatasets%2fpopulationestimatesforukenglandandwalesscotlandandnorthernireland%2fmid2019april2019localauthoritydistrictcodes/ukmidyearestimates20192019ladcodes.xls",
                                 destfile = "raw_data/population_ltla_2019.xls") {
  
  if(!file.exists(destfile)) {
    download.file(url = url,
                  destfile = destfile,
                  mode = "wb")
  }
  
  df = read_excel(destfile,
                  sheet = "MYE2 - Persons",
                  skip = 4) 
  
  return(df)
}


load_cleaned_deaths <- function(directory = "cleaned_data/") {
  
  # Files with format dd-mm-yyyy_cleaned_deaths.csv
  files = dir(directory, 
              pattern = "\\d{4}-\\d{2}-\\d{2}_cleaned_deaths\\.csv" 
  )
  # Reverse and most recent one will be files[1]
  files <- rev(files)
  #file_dates <- as.Date(substr(files, 1, 10), "%Y%m%d")
  full_path = paste0(directory, files[1])
  
  message("Reading in ", files[1])
  
  df = read_csv(full_path)
  
  return(df)
}

get_pop_over_65 <- function(pop) {
  
  # Easiest way to get pop over 65 is to sum all numeric and then subtract all ages (not to double count it)
  pop <- pop %>% 
    select(Code,
           Name,
           `All ages`,
           `65`:`90+`) %>% 
    mutate(pop_over_65 = rowSums(select_if(., is.numeric)) - `All ages`) %>% 
    select(Code,
           Name,
           `All ages`,
           pop_over_65)  
}

get_imd_by_ltla_2020 <- function(imd, pop) {
  
  # Join pop to imd data
  imd <- inner_join(imd, 
                    pop, 
                    by = c("Local Authority District code (2019)" = "Code"))  %>% 
    rename(lad_code_2019 = `Local Authority District code (2019)`,
           lad_name_2019 = `Local Authority District name (2019)`,
           pop_all_ages_2019 = `All ages`,
           pop_over_65_2019 = pop_over_65)
  
  # There's a change in Bucks between 2019 and 2020 where four are merged into one
  # Aylesbury Vale (E07000004), Chiltern (E07000005), South Bucks (E07000006), Wycombe (E07000007)
  # become Buckinghamshire (E06000060)
  
  lad_codes_to_change <- c(
    "E07000004",
    "E07000005",
    "E07000006",
    "E07000007"
  )
  
  BUCKINGHAMSHIRE_NEW_CODE <- "E06000060"
  
  imd <- imd %>% 
    mutate(lad_code_2020 = lad_code_2019,
           lad_name_2020 = lad_name_2019)
  
  imd$lad_name_2020[imd$lad_code_2019 %in% lad_codes_to_change] <- "Buckinghamshire"
  imd$lad_code_2020[imd$lad_code_2019 %in% lad_codes_to_change] <- BUCKINGHAMSHIRE_NEW_CODE
  
  imd <- imd %>% 
    mutate(pop_all_ages_2020 = pop_all_ages_2019,
           pop_over_65_2020 = pop_over_65_2019)
  
  new_bucks_pop_df = imd %>% 
    filter(lad_code_2020==BUCKINGHAMSHIRE_NEW_CODE) %>% 
    select(lad_code_2020, pop_all_ages_2019, pop_over_65_2019) %>% 
    distinct()
  
  new_bucks_pop_over_65 = sum(new_bucks_pop_df$pop_over_65_2019)
  new_bucks_pop_all_ages = sum(new_bucks_pop_df$pop_all_ages_2019)
  
  imd$pop_all_ages_2020[imd$lad_code_2020==BUCKINGHAMSHIRE_NEW_CODE] <- new_bucks_pop_all_ages
  imd$pop_over_65_2020[imd$lad_code_2020==BUCKINGHAMSHIRE_NEW_CODE] <- new_bucks_pop_over_65
  
  imd_by_ltla <- imd %>% 
    group_by(lad_code_2020,
             lad_name_2020,
             pop_all_ages_2020,
             pop_over_65_2020) %>% 
    summarise(imd_score = weighted.mean(
      x = `Index of Multiple Deprivation (IMD) Score`,
      w = pop_all_ages_2020
    )) 
  
  return(imd_by_ltla)
}


imd <- load_imd_data(url = "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/845345/File_7_-_All_IoD2019_Scores__Ranks__Deciles_and_Population_Denominators_3.csv",
                 destfile = "raw_data/imd_scores_2019.csv")

pop <- load_population_data() %>% 
   get_pop_over_65()

imd_by_ltla <- get_imd_by_ltla_2020(imd = imd,
                               pop = pop) 


deaths <- load_cleaned_deaths()

# Make sure all deaths area codes and names are in imd_by_ltla
stopifnot(
  deaths$`Area code` %in% imd_by_ltla$lad_code_2020
)
stopifnot(
  deaths$`Area name` %in% imd_by_ltla$lad_name_2020
)

# So what do we want from the IMD by ltla sheet?

deaths_with_imd <- inner_join(deaths,
                              imd_by_ltla,
                              by = c("Area code" = "lad_code_2020",
                                     "Area name" = "lad_name_2020"))


out_file <- paste0("cleaned_data/",
                   Sys.Date(),
                   "_deaths_imd_pop.csv")

write_csv(deaths_with_imd,
          out_file)

# Now all we need is the UTLA beds for the dot sizes from CQC