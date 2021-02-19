rm(list=ls())
library(dplyr)
library(magrittr)
library(tidyr)
library(readxl)
library(readr)
library(ggplot2)
library(lubridate)
library(ggridges)
library(cowplot)
library(MASS)

if(!require(pkgsimon)){
  install.packages("remotes")
  remotes::install_github("SimonCoulombe/pkgsimon")
} else{
  library(pkgsimon)
}


setwd(dirname(sys.frame(1)$ofile))

deaths <- read_csv("cleaned_data/deaths_per_bed.csv")

deaths <- deaths %>% 
  filter(week_ending <= "2020-12-31")

deaths$month <- format(deaths$week_ending, "%b") %>% 
  factor(levels = month.abb)

monthly_deaths <- deaths %>% 
  group_by(month, `Area name`, `Region name`) %>% 
  summarise(num_deaths = sum(`Number of deaths`))


bandwidth <- bw.bcv(monthly_deaths$num_deaths)


deaths_by_month_biased_cv <- ggplot(data = monthly_deaths, 
                          mapping = aes(
                            x = num_deaths,
                            y = month,
                            fill = stat(x)
                          )
) +   geom_density_ridges_gradient(
  scale = 3, 
  rel_min_height = 0.01, 
  bandwidth = bandwidth,
  color = "black", size = 0.25, 
  quantile_lines = TRUE, 
  quantiles = 2
) +
  scale_x_continuous(
    name = "Number of deaths",
    expand = c(0, 0), 
    breaks = c(0, 5, 10, 15, 20, 25, 30),
    limits = c(-10,35)
  )  +
  scale_y_discrete(name = NULL, expand = c(0, .2, 0, 2.6)) +
  guides(fill = "none") +
  theme_dviz_grid() +
  theme(
    axis.text.y = element_text(vjust = 0),
    plot.margin = margin(3, 7, 3, 1.5)
  ) + colorspace::scale_fill_continuous_sequential(palette = "Heat",
                                                   l1 = 20, l2 = 100, c2 = 0,
                                                   rev = TRUE
  ) +
  ggtitle("Covid-19: England care home deaths by LA per month (biased cross-validation)")

bandwidth <- bw.ucv(monthly_deaths$num_deaths)


deaths_by_month_unbiased_cv <- ggplot(data = monthly_deaths, 
                                    mapping = aes(
                                      x = num_deaths,
                                      y = month,
                                      fill = stat(x)
                                    )
) +   geom_density_ridges_gradient(
  scale = 3, 
  rel_min_height = 0.01, 
  bandwidth = bandwidth,
  color = "black", size = 0.25, 
  quantile_lines = TRUE, 
  quantiles = 2
) +
  scale_x_continuous(
    name = "Number of deaths",
    expand = c(0, 0), 
    breaks = c(0, 5, 10, 15, 20, 25, 30),
    limits = c(-10,35)
  )  +
  scale_y_discrete(name = NULL, expand = c(0, .2, 0, 2.6)) +
  guides(fill = "none") +
  theme_dviz_grid() +
  theme(
    axis.text.y = element_text(vjust = 0),
    plot.margin = margin(3, 7, 3, 1.5)
  ) + colorspace::scale_fill_continuous_sequential(palette = "Heat",
                                                   l1 = 20, l2 = 100, c2 = 0,
                                                   rev = TRUE
  ) +
  ggtitle("Covid-19: England care home deaths by LA per month (unbiased cross-validation)")

deaths_by_month_facets_biased <- deaths_by_month_biased_cv +
  facet_wrap(`Region name`~.)

deaths_by_month_facets_unbiased <- deaths_by_month_unbiased_cv +
  facet_wrap(`Region name`~.)


if(!dir.exists("plots")) dir.create("plots")
ggsave(plot = deaths_by_month_biased_cv, 
  filename = "plots/deaths_by_month_biased.png")
ggsave(plot = deaths_by_month_unbiased_cv, 
  filename = "plots/deaths_by_month_unbiased.png")

ggsave(plot = deaths_by_month_facets_biased, 
filename = "plots/deaths_by_month_biased_facets.png", 
  width = 12.8*2,
  height = 9.2*2,
  units = "cm")
ggsave(plot = deaths_by_month_facets_unbiased, 
  filename = "plots/deaths_by_month_unbiased_facets.png",
  width = 12.8*2,
  height = 9.2*2,
  units = "cm")
