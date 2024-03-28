#### Preamble ####
# Purpose: Scrapes and saves the data from https://www.boxofficemojo.com/
# Author: Qi Er (Emma) Teng
# Date: 28 March 2024
# Contact: e.teng@mail.utoronto.ca
# License: MIT
# Note: Datasets from IMDb are downloaded manually at https://developer.imdb.com/non-commercial-datasets/
# Note: All web scrapping is done with permission from https://www.boxofficemojo.com/robots.txt


#### Workspace setup ####
library(tidyverse)
library(rvest)

#### Function for Scrapping ####
scrape_tab <- function(html_list, yrlist){
  
  for (i in c(1:length(html_list))) {
    web_page <- read_html(html_list[i])
    
    table_yr <- web_page |>
      html_elements(xpath = "//*[contains(@class, 'a-section imdb-scroll-table-inner')]") |>
      html_table()
    
    pathstr=paste("data/raw_data/", toString(yrlist[i]), ".csv", sep = "")
    
    write_csv(table_yr[[1]], pathstr)
  }
}


#### Get HTML ####
htmls_yr <- c("https://www.boxofficemojo.com/year/2019/?sort=grossToDate&ref_=bo_yld__resort#table",
              "https://www.boxofficemojo.com/year/2020/?sort=grossToDate&ref_=bo_yld__resort#table",
              "https://www.boxofficemojo.com/year/2021/?sort=grossToDate&ref_=bo_yld__resort#table",
              "https://www.boxofficemojo.com/year/2022/?sort=grossToDate&ref_=bo_yld__resort#table")

yr=c(2019, 2020, 2021, 2022)

#### Save data ####
scrape_tab(htmls_yr, yr)