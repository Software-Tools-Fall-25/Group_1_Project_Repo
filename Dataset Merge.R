#Mia Raineri
install.packages("readxl")
library(readxl)

#Merging PLACES and Food Access Data

food_data <- read_excel("data/FoodAccess_Updated.xlsx", sheet = "Food Access Research Atlas" )
health_data <- read_excel("data/PLACES.xlsx")

head(food_data)
head(health_data)

# Since the datasets had different ways of tracking location (county vs city), we will split their code to better merge by the right geographical markers
library(dplyr)

# Split CensusTract variable in Dataset A
USDA <- food_data %>%
  mutate(
    StateFIPS = substr(CensusTract, 1, 2),
    CountyFIPS = substr(CensusTract, 3, 5),
    TractCode = substr(CensusTract, 6, 11)
  )

# Split TractFIPS variable in Dataset B
PLACES <- health_data %>%
  mutate(
    StateFIPS = substr(TractFIPS, 1, 2),
    CountyFIPS = substr(TractFIPS, 3, 5),
    TractCode = substr(TractFIPS, 6, 11)
  )

# Merge by State + County + Tract
merged <- merge(USDA, PLACES, by = c("StateFIPS", "CountyFIPS", "TractCode"), all = TRUE)

View(merged)

#Saving merged dataset as csv file
write.csv(merged, "merged_dataset.csv", row.names = FALSE)


#some counties are missing data since the health data did not cover those areas - food data was more granual 


