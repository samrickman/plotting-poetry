
library(dplyr)
library(magrittr)
library(readr)
library(tidyr)
library(readxl)
library(ggplot2)
library(plotly)
library(ggthemes)
library(scales)
library(leaflet)
library(readr)
library(RColorBrewer)
library(sf)
library(htmlwidgets)


rm(list=ls())

setwd(dirname(rstudioapi::getSourceEditorContext()$path))

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
  
  if(!dir.exists("raw_data/shapefile")) dir.create("raw_data/shapefile")
  
  withr::with_dir("raw_data/", unzip(zipfile = "lad_boundaries_2020.zip", exdir = "shapefile"))
}

# From: https://geoportal.statistics.gov.uk/datasets/local-authority-districts-may-2020-boundaries-uk-buc
shapefile_url <- "https://opendata.arcgis.com/datasets/910f48f3c4b3400aa9eb0af9f8989bbe_0.zip?outSR=%7B%22latestWkid%22%3A27700%2C%22wkid%22%3A27700%7D"
shapefile_destfile <- "raw_data/lad_boundaries_2020.zip"

download_file(url = shapefile_url,
              destfile = shapefile_destfile)

# Get shapefile in correct format
england_shape <- england_shape <- st_read("raw_data/shapefile/Local_Authority_Districts__May_2020__UK_BUC.shp")
england_shape <- england_shape[england_shape$LAD20CD %in% deaths$`Area code`,]
england_st <- st_transform(england_shape, "+proj=longlat +datum=WGS84")

# Limit deaths to most recent week
deaths <- deaths %>% 
  filter(`Week number`==max(`Week number`))

# Set the colors
reds <- brewer.pal(9, 'Reds')
newcol <- colorRampPalette(reds)
ncols <- nrow(england_st)
big_reds <- newcol(ncols) #apply the function to get 312 colours

deaths <- deaths %>% 
  arrange(deaths_per_1k_beds) #
deaths$fill_color <- big_reds

# Set text popup
deaths$popup = paste0(
  "<b>", deaths$`Area name`, "</b><br>",
  "Deaths per 1,000 care home residents: ", signif(deaths$deaths_per_1k_beds, 2)
)

deaths_map_df <- inner_join(england_st, 
                         deaths,
                         by = c("LAD20CD" = "Area code"))

# Add map title with some custom css
tag.map.title <- htmltools::tags$style(htmltools::HTML("
  .leaflet-control.map-title { 
    transform: translate(-50%,20%);
    position: fixed !important;
    left: 75%;
    text-align: center;
    padding-left: 10px; 
    padding-right: 10px; 
    background: rgba(255,255,255,0.75);
    font-weight: bold;
    font-size: 28px;
  }
"))

title <- htmltools::tags$div(
  tag.map.title, htmltools::HTML("Covid-19: care home deaths per 1,000 residents")
)  

deaths_map <- leaflet() %>% addTiles %>% 
  addPolygons(data=deaths_map_df, 
              weight=2, 
              opacity=1, 
              color= "black",
              fillOpacity = 0.7,
              fillColor = ~fill_color,
              popup = ~popup
  ) %>% 
  setView(lng = -1.464858, lat = 52.561911 ,zoom=7) %>% 
  addControl(title, position = "topleft", className="map-title")


withr::with_dir("cleaned_data/",
                saveWidget(deaths_map, file="deaths_map.html")
)

