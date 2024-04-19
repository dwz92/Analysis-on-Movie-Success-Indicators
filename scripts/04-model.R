#### Preamble ####
# Purpose: Models... [...UPDATE THIS...]
# Author: Qi Er (Emma) Teng
# Date: 28 March 2024
# Contact: e.teng@mail.utoronto.ca
# License: MIT


#### Workspace setup ####
library(tidyverse)
library(rstanarm)
library(arrow)
library(dplyr)
library(knitr)
library(ggplot2)
library(modelsummary)
library(tidybayes)
library(broom.mixed)
library(bayesplot)

#### Read data ####
analysis_data <- read_parquet("data/analysis_data/movcomb.parquet")

analysis_data$success <- as.numeric(analysis_data$averageRating >= 5)
analysis_data$release_year<-as.factor(analysis_data$release_year)
analysis_data$theaters<-as.numeric(analysis_data$theaters)


### Model data ####
second_model <-
  stan_glmer(
    formula = success ~ (1 | release_year) + theaters,
    data = analysis_data,
    family = binomial(link = "logit"),
    prior = normal(0, 2.5, autoscale = TRUE), 
    prior_intercept = normal(0, 2.5, autoscale = TRUE),
    prior_aux = exponential(rate = 1, autoscale = TRUE)
  )


modelsummary(second_model)

#### Save model ####
saveRDS(
  second_model,
  file = "models/second_model.rds"
)

