## code to prepare `DATASET` dataset goes here

# Load required libraries
library(dplyr)
library(readr)
library(tidyverse)

# Load the data
noc_region <- read_csv("data-raw/noc_region.csv")

# Remove the 3rd column from noc_region
noc_region <- noc_region[, -3]

# Load the Olympics data
olympics <- read_csv("data-raw/olympic.csv")

# Perform inner join on the noc_region and olympics data
cleaned_data <- inner_join(olympics, noc_region, by = c("Team" = "reg"))


# Save to /data folder into .rda file
usethis::use_data(cleaned_data, overwrite = TRUE)
