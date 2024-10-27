## code to prepare `key_crop_yields` dataset goes here

library(janitor)
library(tidyverse)
url <- 'https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-09-01/key_crop_yields.csv'

key_crop_yields <- read_csv(url) %>%
  clean_names() %>%
  pivot_longer(
    cols = -c(entity, code, year),
    names_to = "crop",
    values_to = "yield",
    names_pattern = "([^_]+)"
  )


usethis::use_data(key_crop_yields, overwrite = TRUE)
