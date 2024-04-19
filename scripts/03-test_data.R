#### Preamble ####
# Purpose: Tests the final dataset
# Author: Qi Er (Emma) Teng
# Date: 28 March 2024
# Contact: e.teng@mail.utoronto.ca
# License: MIT


#### Workspace setup ####
library(tidyverse)
library(testthat)
library(here)
library(arrow)

#### Test data ####
dataset <- read_parquet(here::here("data/analysis_data/movcomb.parquet"))

# Test that 'release_year' is between 2019 and 2022
test_that("Release years are between 2019 and 2022", {
  expect_true(all(dataset$release_year %in% c(2019, 2020, 2021, 2022)))
})

# Test that 'tconst' values are unique
test_that("tconst identifiers are unique", {
  expect_true(all(duplicated(dataset$tconst) == FALSE))
})


# Test that 'numVotes', 'theaters' are positive
test_that("Numerical values are positive", {
  expect_true(all(dataset$numVotes >= 0))
  expect_true(all(dataset$theaters >= 0))
})

