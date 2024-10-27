# Load necessary libraries
library(dplyr)
library(tidyr)
library(readxl)
library(usethis)

# Read the raw data
olym_rawdata <- read_csv("data-raw/dataset_olympics.csv")
attr_rawdata <- read_xlsx("data-raw/toughestsport_attributes.xlsx")

# Step 1: Clean Olympics Data
## Remove irrelevant columns and filter for relevant Olympic editions
oly_data <- olym_rawdata |>
  select(-Medal, -Games, -ID, -Season) |>  # Remove unnecessary columns
  filter(Year >= 1948) |>                  # Keep data from 1948 onward
  drop_na()                                # Remove rows with NA values

# Step 2: Manipulate Sport Names for Easier Processing
oly_data <- oly_data |>
  mutate(Sport = case_when(
    Sport %in% c("Luge", "Skeleton") ~ "Bobsleigh",
    Sport %in% c("Taekwondo", "Judo") ~ "Martial Arts",
    Sport == "Softball" ~ "Baseball",
    Sport == "Short Track Speed Skating" ~ "Speed Skating",
    TRUE ~ Sport)) |>

  # Use regex to rename based on the "Event" column
  mutate(Sport = case_when(
    grepl("Pole Vault", Event) ~ "Athletics_PoleVault",
    grepl("High Jump", Event) ~ "Athletics_HighJumps",
    grepl("Throw|Shot Put", Event) ~ "Athletics_Weights",
    grepl("100|110|200|400", Event) ~ "Athletics_Sprints",
    grepl("800|1,500|3,000", Event) ~ "Athletics_MidDistance",
    grepl("5,000|10,000", Event) ~ "Athletics_LongDistance",
    grepl("Sprint", Event) & Sport == "Cycling" ~ "Cycling_Sprints",
    grepl("50 metres|100 metres", Event) & Sport == "Swimming" ~ "Swimming_Sprints",
    TRUE ~ Sport)) |>

  # Further refining Sport names
  mutate(Sport = case_when(
    Sport == "Swimming" ~ "Swimming_Distance",
    Sport == "Cycling" ~ "Cycling_Distance",
    grepl("Jump", Event) & Sport == "Athletics" ~ "Athletics_Jumps",
    TRUE ~ Sport))  # Final default case

# Step 3: Create a Summary by Year
oly_byyear <- oly_data |>
  group_by(Year) |>
  distinct(Sport) |>
  ungroup()  # Return to a regular data frame

# Step 4: Clean Attributes Data
attr_data <- attr_rawdata |>
  mutate(SPORT = case_when(
    SPORT == "Skiing: Alpine" ~ "Alpine Skiing",
    SPORT == "Skiing: Freestyle" ~ "Freestyle Skiing",
    SPORT == "Racquetball/Squash" ~ "Racquets",
    grepl("Track and Field", SPORT) ~ sub("Track and Field: ", "Athletics_", SPORT),
    TRUE ~ SPORT)) |>
  rename(Sport = SPORT) |>  # Rename column
  filter(Sport != "footballz")  # Remove irrelevant sports

# Step 5: Transform Attribute Data to Long Format
attr_long <- attr_data |>
  select(-TOTAL, -RANK) |>  # Remove unnecessary columns
  pivot_longer(cols = -Sport, names_to = "attr", values_to = "values")

# Step 6: Rank and Select Top 3 Attributes for Each Sport
top_attrs <- attr_long |>
  group_by(Sport) |>
  arrange(desc(values)) |>
  slice_head(n = 3) |>  # Keep top 3 attributes
  mutate(rank = row_number()) |>
  select(Sport, attr, values, rank)

# Step 7: Pivot Wider to Get Top 3 Attributes in Separate Columns
attr_top_wide <- top_attrs |>
  pivot_wider(names_from = rank, values_from = c(attr, values), names_sep = "_") |>
  rename(
    Top_1_attr = attr_1, Top_1_value = values_1,
    Top_2_attr = attr_2, Top_2_value = values_2,
    Top_3_attr = attr_3, Top_3_value = values_3)

# Step 8: Combine Data into a Unified Data Frame
olym_final <- left_join(oly_data, attr_top_wide, by = "Sport") |>
  drop_na()  # Remove rows with NA values

# Final Data Validation
if (nrow(olym_final) == 0) {
  stop("Final dataset is empty; please check previous cleaning steps.")
}

# Save the cleaned data to the data/ directory in .rda format
usethis::use_data(olym_final, overwrite = TRUE)
