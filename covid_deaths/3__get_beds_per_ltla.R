library(dplyr)
library(magrittr)
library(tidyr)
library(readxl)
library(readr)


rm(list=ls())
setwd(dirname(sys.frame(1)$ofile))

download_data <- function(url, 
                          destfile) {
  if(!file.exists(destfile)) {
    download.file(url = url,
                  destfile = destfile,
                  mode = "wb")
  } else {
    message("File already downloaded!")
  }
  
}

clean_cqc_file <- function(in_file,
                           out_file) {
  
  if(file.exists(out_file)) {
    message("CQC file already cleaned.")
    return()
  }
  
  # Read in data from sheet 2 (sheet 1 is just info)
  # just read in column names but no rows (to fix column types)
  cqc <- readxl::read_xlsx(in_file, 
                           sheet=2,
                           n_max = 0)
  
  # readxl gets confused about column types so we have to say that all
  # columns from the Regulated activity columns onward are text
  # then we'll make them logical below
  # Any before Regulated activity it can guess correctly
  first_filter_column <- grep("^Regulated activity", names(cqc))[1]
  num_guess_cols <- first_filter_column-1 
  num_text_cols <- dim(cqc)[2]-num_guess_cols
  
  # Define column types for the filter columns
  # (otherwise it thinks the Service type or Service user band filter columns 
  # are logical and gets confused by Y/N)
  col_types = c(rep("guess", times=num_guess_cols), rep("text", times = num_text_cols))
  
  # Now read in full data from sheet 1, first 6 rows are header rows 
  cqc <- readxl::read_xlsx(in_file, 
                           sheet=2,
                           col_types = col_types)
  
  #replace spaces, forward slash in column names with underscores
  names(cqc) <- gsub(" |/", "_", names(cqc))
  # remove dashes, commas, question marks
  names(cqc) <- gsub("-|,|\\?", "", names(cqc))
  
  
  # Replace the 'Y' from the CQC data with TRUE and NA with FALSE 
  # so they are now logical vectors
  cqc[,first_filter_column:ncol(cqc)]  %<>%  
    as.data.frame() %>%  sapply(recode, "Y" = TRUE) %>% 
    as.data.frame() %>% sapply(replace_na, FALSE) %>% 
    as.data.frame()
  
  
  
  message("Writing cleaned CQC file to: ", out_file)
  write_rds(cqc, out_file)
  
}

load_postcode_data <- function(postcode_url = "https://www.arcgis.com/sharing/rest/content/items/4df8a1a188e74542aebee164525d7ca9/data",
                               postcode_raw_file = "raw_data/postcode_data.zip") {
  if(!dir.exists("raw_data/postcode_data")) {
    
    # Download postcode data
    download_data(url = postcode_url,
                  destfile = postcode_raw_file)
    
    unzip(zipfile = postcode_raw_file, 
          exdir = "raw_data/postcode_data")  
    
    postcodes <- read_csv("raw_data/postcode_data/Data/NSPL_NOV_2020_UK.csv")
    postcodes <- postcodes[grepl("^E", postcodes$laua),] # England codes start with E, Scotland with S etc.
    
    postcodes <- postcodes %>% 
      select(pcds,
             laua) %>% 
      mutate(postcode_no_space <- gsub("\\s", "", pcds))
    
    write_csv(postcodes, 
              "raw_data/postcodes_to_ltla_2020.csv")
  } else {
    message("Postcode data already unzipped!")
    postcodes <- read_csv("raw_data/postcodes_to_ltla_2020.csv")
  }
  
  return(postcodes)
}

cqc_url = "https://www.cqc.org.uk/sites/default/files/1_December_2020_HSCA_Active_Locations.xlsx"
cqc_raw_file = "raw_data/2020-12-01_cqc.xlsx"
cqc_cleaned_file = "cleaned_data/2020-12-01_cqc_cleaned.rds"

# Download CQC data
download_data(url = cqc_url,
              destfile = cqc_raw_file)

clean_cqc_file(in_file = cqc_raw_file,
               out_file = cqc_cleaned_file)

postcodes <- load_postcode_data()

cqc <- read_rds(cqc_cleaned_file)

cqc$postcode_no_space <- gsub("\\s", "", cqc$Location_Postal_Code)

# We lose 7 invalid postcodes - that's 66 beds out of 450k - we can live with that
sum(!cqc$postcode_no_space %in% postcodes$postcode_no_space) # 7 
sum(cqc$Care_homes_beds[!cqc$postcode_no_space %in% postcodes$postcode_no_space]) # 66
sum(cqc$Care_homes_beds[cqc$postcode_no_space %in% postcodes$postcode_no_space]) # 457737

# Join lad code
cqc <- inner_join(cqc, postcodes, by = "postcode_no_space") %>% 
  rename(lad_code_2020 = laua)

beds_per_ltla <- cqc %>% 
  group_by(lad_code_2020) %>% 
  summarise(total_beds_ltla = sum(Care_homes_beds, na.rm = T))

# Assert none are NA
stopifnot(
  !is.na(beds_per_ltla$total_beds_ltla)
)

write_csv(beds_per_ltla,
          "cleaned_data/beds_per_ltla.csv")
