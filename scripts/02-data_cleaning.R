#### Preamble ####
# Purpose: Cleans the raw movie data and join with IMDb data
# Author: Qi Er (Emma) Teng
# Date: 28 March 2024
# Contact: e.teng@mail.utoronto.ca
# License: MIT
# Note: Datasets from IMDb are downloaded manually at https://developer.imdb.com/non-commercial-datasets/
# Note: All web scrapping is done with permission from https://www.boxofficemojo.com/robots.txt

#### Workspace setup ####
library(tidyverse)
library(dplyr)
library(here)
library(janitor)
library(arrow)

#### Join movie by yrs ####
mov2019 <- read.csv(here::here("data/raw_data/2019.csv"))
mov2020 <- read.csv(here::here("data/raw_data/2020.csv"))
mov2021 <- read.csv(here::here("data/raw_data/2021.csv"))
mov2022 <- read.csv(here::here("data/raw_data/2022.csv"))

mov2019 <- mov2019 |>
  mutate("release_year" = "2019") |>
  select(Release, Theaters, Total.Gross, Release.Date, release_year)

mov2020 <- mov2020 |>
  mutate("release_year" = "2020") |>
  select(Release, Theaters, Total.Gross, Release.Date, release_year)

mov2021 <- mov2021 |>
  mutate("release_year" = "2021") |>
  select(Release, Theaters, Total.Gross, Release.Date, release_year)

mov2022 <- mov2022 |>
  mutate("release_year" = "2022") |>
  select(Release, Theaters, Total.Gross, Release.Date, release_year)

mov1922 <- bind_rows(mov2019, mov2020, mov2021, mov2022)

mov1922 <- mov1922 |>
  clean_names() |>
  mutate(theaters = ifelse(theaters == "-", 0, theaters)) |>
  filter(release_date != "-")

write_parquet(x = mov1922,
              sink = "data/analysis_data/mov1922.parquet")


#### Join title akas with mov1922 on title = release ####
titlebasic <- read_tsv(here::here("data/raw_data/title.basics.tsv"))
titlerate <- read_tsv(here::here("data/raw_data/title.ratings.tsv"))

##Save sample of raw data##

write_parquet(titlebasic[1:10,],
          "data/analysis_data/titlebasicraw.parquet")
write_parquet(titlerate[1:10,],
              "data/analysis_data/titlerateraw.parquet")

titlecomb <- titlebasic |>
  select(tconst, originalTitle, startYear, genres, titleType) |>
  filter(originalTitle %in% mov1922$release, titleType == "movie") |>
  inner_join(titlerate, by = c("tconst" = "tconst"))

mov_s2 <- titlecomb |>
  rename(
    "release" = originalTitle,
    "release_year" = startYear
  )

## Clean Data for Plotting##

mov_s2 <- mov_s2 |>
  inner_join(mov1922, by = c("release", "release_year"))

mov_s2$plot_date <- as.Date(mov_s2$release_date, format="%b %d")

mov_s2$release_year <- as.factor(mov_s2$release_year)

mov_s2$theaters <- as.numeric(gsub(",", "", mov_s2$theaters))
  
mov_s2

write_parquet(x = mov_s2,
             sink = "data/analysis_data/movcomb.parquet")