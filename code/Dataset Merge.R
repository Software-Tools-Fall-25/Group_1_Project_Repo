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

#Using merged dataset to summarize KPIs

library(dplyr)
library(knitr)

#General KPIs of Data
summary_kpis <- merged %>%
  summarise(
    mean_obesity = mean(OBESITY_CrudePrev, na.rm = TRUE),
    median_obesity = median(OBESITY_CrudePrev, na.rm = TRUE),
    sd_obesity = sd(OBESITY_CrudePrev, na.rm = TRUE),
    mean_diabetes = mean(DIABETES_CrudePrev, na.rm = TRUE),
    median_diabetes = median(DIABETES_CrudePrev, na.rm = TRUE),
    sd_diabetes = sd(DIABETES_CrudePrev, na.rm = TRUE),
    percent_LILA = mean(LILATracts_1And10, na.rm = TRUE) * 100,
    percent_LA = mean(LATracts1, na.rm = TRUE) * 100,
    mean_poverty = mean(PovertyRate, na.rm = TRUE)
  )

summary_kpis

kpi_table <- summary_kpis %>%
  tidyr::pivot_longer(
    everything(),
    names_to = "Metric",
    values_to = "Value"
  )

library(gt)
library(webshot2)

kpi_gt <- kpi_table %>%
  gt() %>%
  fmt_number(columns = "Value", decimals = 3) %>%
  tab_header(
    title = "Key Performance Indicators",
    subtitle = "Obesity, Diabetes, Poverty, and Food Access Measures"
  )

gtsave(kpi_gt, "kpi_table.png")


str(merged[, c("PovertyRate", "LILATracts_1And10", "TractSNAP", "lapop1share")])
#lapop1share - as.numeric(lapop1share)


#Creating a Food Insecurity Index
merged <- merged %>%
  mutate(
    food_insecurity_index = scale(PovertyRate) +
      scale(LILATracts_1And10) +
      scale(TractSNAP) +
      scale(lapop1share)
  )

summary(merged$food_insecurity_index)

#Food insecurity v Obesity
library(ggplot2)
ggplot(merged, aes(food_insecurity_index, OBESITY_CrudePrev)) +
  geom_point() +
  geom_smooth(method = "lm")

ggsave("fi_vs_obesity.png", width = 6, height = 4)

#Correlation of food insecurity to obesity and diabetes
cor(merged$food_insecurity_index, merged$OBESITY_CrudePrev, use = "complete.obs")
cor(merged$food_insecurity_index, merged$DIABETES_CrudePrev, use = "complete.obs")



#Putting FI index into quintiles - for tableau
#Map low to high food insecurity areas
merged <- merged %>%
  mutate(
    fi_quintile = ntile(food_insecurity_index, 5)
  )


#Gives us the top 20 highest food insecure tracts
merged %>%
  arrange(desc(food_insecurity_index)) %>%
  slice(1:20)




#KPI of LILA vs Non-LILA
lila_compare <- merged %>%
  group_by(LILATracts_1And10) %>%
  summarise(
    mean_obesity = mean(OBESITY_CrudePrev, na.rm = TRUE),
    mean_diabetes = mean(DIABETES_CrudePrev, na.rm = TRUE),
    mean_food_insecurity = mean(food_insecurity_rate, na.rm = TRUE),
    n = n()
  )
lila_compare

#correlation analysis
library(reshape2)
library(ggplot2)


cor_vars <- merged %>%
  select(
    food_insecurity_index,
    OBESITY_CrudePrev,
    DIABETES_CrudePrev,
    PovertyRate,
    TractSNAP,
    LILATracts_1And10
  )

cor_matrix <- cor(cor_vars, use = "complete.obs")
cor_matrix

cor_melt <- melt(cor_matrix)

heatmap_plot <- ggplot(cor_melt, aes(Var1, Var2, fill = value)) +
  geom_tile(color = "white") +
  scale_fill_gradient2(
    low = "blue", high = "red", mid = "white",
    midpoint = 0, limit = c(-1, 1)
  ) +
  geom_text(aes(label = round(value, 2)), size = 4) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    axis.title = element_blank()
  ) +
  ggtitle("Correlation Matrix Heatmap")

heatmap_plot

ggsave("correlation_heatmap.png", heatmap_plot, width = 7, height = 6, dpi = 300)


