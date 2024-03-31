#### Preamble ####
# Purpose: Simulates... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 11 February 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
library(tidyverse)
library(ggplot2)
library(dplyr)
library(kableExtra)
library(ggrepel)

#### Simulate data ####
movcomb <- read_parquet(here::here("data/analysis_data/movcomb.parquet"))

genres_list <- strsplit(movcomb$genres, split = ",")

# Unlist the genres into a vector, then get the unique elements
unique_genres <- unique(unlist(genres_list))

# Print unique genres
print(unique_genres)

df_long <- movcomb

df_long <- df_long %>%
  separate_rows(genres, sep = ",") %>%
  mutate(genres = trimws(genres)) %>%
  group_by(genres) %>%
  summarise(
    averageRating = mean(averageRating, na.rm = TRUE),
    numVotes = sum(numVotes, na.rm = TRUE)  # This will be used for the bubble sizes
  )

# Create the plot
ggplot(df_long, aes(x = reorder(genres, numVotes), y = averageRating, size = numVotes, label = genres)) +
  geom_point(alpha = 0.5, color = "blue") +
  geom_text_repel(
    aes(label = genres),
    size = 5,  # Adjust the size of the text to fit inside the bubbles
    max.overlaps = Inf,  # Allow text labels to overlap each other if necessary
    point.padding = NA,  # Control the distance between the text and the point
    box.padding = 0.35,  # Adjust the padding around the text
    segment.color = NA  # Hide the repelling lines
  ) +
  scale_size_continuous(range = c(5, 30)) +  # Adjust range to control bubble sizes
  theme_minimal() +
  theme(legend.position = "none",  # Hide the legend for size
        axis.text.x = element_text(angle = 45, hjust = 1)) +  # Rotate x labels
  labs(x = "Genre", y = "Average Rating", title = "Movie Ratings by Genre")