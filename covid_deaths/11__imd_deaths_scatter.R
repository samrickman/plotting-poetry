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
library(ggpubr)

rm(list=ls())

#setwd(dirname(rstudioapi::getSourceEditorContext()$path))

# Load deaths data
deaths <- read_csv("cleaned_data/deaths_per_bed.csv")

deaths_for_plot  <- deaths %>% 
    filter(week_ending==max(week_ending))  %>% 
    dplyr::select(`LA name`,
    "Bed based" = deaths_per_1k_beds,
    "Community" = death_rate_per_1k_over_65_gen_pop,
    imd_score,
    `Region name`,
    south_mid_north
    )  %>% 
    gather(key = "Setting",
    value = "Death rate", 
    -c(`LA name`,
     imd_score,     
    `Region name`,
    south_mid_north)) 

community = deaths_for_plot  %>% 
filter(Setting == "Community")

carehome = deaths_for_plot  %>% 
filter(Setting == "Bed based")


ggplot(deaths_for_plot, mapping = aes(
    x = imd_score,
    y = `Death rate`
)) +
    geom_point(mapping = aes(
        color = south_mid_north
    ), size =2) + 
    geom_smooth(method="lm", span = 10) + 
   ggtitle("Covid-19: Mortality by deprivation") + 
   xlab("IMD score (population-weighted mean of LSOA score)") +
   theme_stata() + 
   theme(legend.title = element_blank(),
   axis.text.y.right = element_text()) + 
   facet_wrap(Setting ~ ., scale = "free") + 
   stat_cor(method = "pearson") + 
     # Custom the Y scales:
  scale_y_continuous(
    
    # Features of the first axis
    name = "Deaths per 1,000 beds",
    
    # Add a second axis and specify its features
    sec.axis = sec_axis( trans="identity", name="Deaths per 1,000 population")
  )

  
ggplot(community, mapping = aes(
    x = imd_score,
    y = `Death rate`
)) +
    geom_point(mapping = aes(
        color = south_mid_north
    ), size =2) + 
    geom_smooth(method="lm", span = 10) + 
   ggtitle("Covid-19: Mortality by deprivation") + 
   xlab("IMD score (population-weighted mean of LSOA score)") +
   theme_stata() + 
   theme(legend.title = element_blank(),
   axis.text.y.right = element_text()) + 
   facet_wrap(`Region name` ~ .) + 
   stat_cor(method = "pearson") + 
     # Custom the Y scales:
  scale_y_continuous(
    
    # Features of the first axis
    name = "Deaths per 1,000 beds",
    
    # Add a second axis and specify its features
    sec.axis = sec_axis( trans="identity", name="Deaths per 1,000 population")
  )
    


  
ggplot(carehome, mapping = aes(
    x = imd_score,
    y = `Death rate`
)) +
    geom_point(mapping = aes(
        color = south_mid_north
    ), size =2) + 
    geom_smooth(method="lm", span = 10) + 
   ggtitle("Covid-19: Mortality by deprivation") + 
   xlab("IMD score (population-weighted mean of LSOA score)") +
   theme_stata() + 
   theme(legend.title = element_blank(),
   axis.text.y.right = element_text()) + 
   facet_wrap(`Region name` ~ .) + 
   stat_cor(method = "pearson") + 
     # Custom the Y scales:
  scale_y_continuous(
    
    # Features of the first axis
    name = "Deaths per 1,000 beds",
    
    # Add a second axis and specify its features
    sec.axis = sec_axis( trans="identity", name="Deaths per 1,000 population")
  )

ggsave(filename = "plots/deaths_by_deprivation_carehome_region.png", 
  width = 12.8*2,
  height = 7.2*2,
  units = "cm")