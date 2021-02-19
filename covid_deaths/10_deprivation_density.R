
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

deaths$Deprivation  <- factor(deaths$Deprivation, levels = c("Low", "Medium", "High"))

deaths_for_plot  <- deaths %>% 
    dplyr::select(`LA name`,
    "Bed based" = deaths_per_1k_beds,
    "Community" = death_rate_per_1k_over_65_gen_pop,
    Deprivation
    )  %>% 
    gather(key = "Setting",
    value = "Death rate", 
    -c(`LA name`, Deprivation)) 


community = deaths_for_plot  %>% 
filter(Setting == "Community")

carehome = deaths_for_plot  %>% 
filter(Setting == "Bed based")

ggplot(data = community,
  mapping = aes(
    x = `Death rate`
  )) + 
  geom_density(aes(fill = Deprivation),
  alpha = 0.5) +
  theme_gdocs() + 
    scale_fill_manual(values = c("lightblue", "lightgreen", "pink")) +
    ylab("Density") +
    xlab("Deaths per 100k pop over 65") +
    ggtitle("Covid-19: community death rate by deprivation") #+
    facet_wrap(. ~ Deprivation, scales = "free") 

ggsave("plots/deprivation_density_facets.png")



# ggplot(data = community,
#   mapping = aes(
#     x = `Death rate`
#   )) + 
#   geom_density(aes(fill = Deprivation),
#   alpha = 0.5) +
#   theme_gdocs() + 
#     scale_fill_manual(values = c("lightblue", "lightgreen", "pink")) +
#     ylab("Density") +
#     xlab("Deaths per 1,000 care home beds") +
#     ggtitle("Covid-19: care home death rate by deprivation") +
#     facet_wrap(. ~ Deprivation, scales = "free") 




# ggplot(data = deaths,
#   mapping = aes(
#     x = deaths_per_1k_beds
#   )) + 
#   geom_density(aes(fill = Deprivation),
#   alpha = 0.5) +
#   theme_stata() + 
#     scale_fill_manual(values = c("lightblue", "lightgreen", "pink")) +
#     ylab("Density") +
#     xlab("Deaths per 1,000 care home beds") +
#     ggtitle("Covid-19: care home death rate by deprivation")

# ggplot(data = deaths,
#   mapping = aes(
#     x = death_rate_per_1k_over_65_gen_pop
#   )) + 
#   geom_density(aes(fill = Deprivation),
#   alpha = 0.5) +
#   theme_stata() + 
#     scale_fill_manual(values = c("lightblue", "lightgreen", "pink")) +
#     ylab("Density") +
#     xlab("Deaths per 1,000 care home beds") +
#     ggtitle("Covid-19: care home death rate by deprivation")




# ggsave("plots/deprivation_densty.png", 
#  width = 12.8*2,
#   height = 7.2*2,
#   units = "cm")

# names(deaths_pol_most_recent)
