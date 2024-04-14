#### Preamble ####
# Purpose: Simulates... [...UPDATE THIS...]
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
movcomb <- read_parquet(here::here("data/analysis_data/movcomb.parquet"))

genres_list <- strsplit(movcomb$genres, split = ",")

# Unlist the genres into a vector, then get the unique elements
unique_genres <- unique(unlist(genres_list))

# Print unique genres
print(unique_genres)

df_long <- movcomb

df_long <- df_long |>
  filter(release_year == 2022) |>
  separate_rows(genres, sep = ",") |>
  mutate(genres = trimws(genres)) |>
  group_by(genres) |>
  summarise(
    
    averageRating = mean(averageRating, na.rm = TRUE),
    numRele = sum(theaters, na.rm = TRUE)
  )



# Create the plot
ggplot(df_long, aes(x = reorder(genres, numRele), y = averageRating, size = numRele, label = genres)) +
  geom_point(alpha = 0.5, color = "lightblue") +
  geom_text_repel(
    aes(label = genres),
    size = 5,  
    max.overlaps = Inf, 
    point.padding = NA,
    box.padding = 0.35,
    segment.color = NA 
  ) +
  scale_size_continuous(range = c(5, 30)) +
  theme_minimal() +
  theme(legend.position = "none",
        axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(x = "Genre", y = "Average Rating", title = "Movie Ratings by Genre in 2022")