#### Preamble ####
# Purpose: Simulates the final dataset
# Author: Qi Er (Emma) Teng
# Date: 28 March 2024
# Contact: e.teng@mail.utoronto.ca
# License: MIT


#### Workspace setup ####
library(tidyverse)
library(ggplot2)
library(dplyr)
library(kableExtra)
library(ggrepel)
library(arrow)

#### Simulate data ####
set.seed(1008)

# Initialize a tibble
simulated_data <- tibble(
  year = sample(c("2019", "2020", "2021", "2022"), size = 50, replace = TRUE),
  rating = sample(0:10, size = 50, replace = TRUE),
  release_theatres = rpois(50, lambda = 15000),
  total_gross = rpois(50, lambda = 200000),
  title = sample(c("title"), size = 50, replace = TRUE)
)

simulated_data