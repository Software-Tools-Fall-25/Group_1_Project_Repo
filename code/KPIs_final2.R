#Mia Raineri
#Edited by Emily Broderick

library(readxl)
#Merging PLACES and Food Access Data

food_data <- read_excel("/Users/emilybroderick/Desktop/R/STDA/FoodAccess_Updated.xlsx", sheet = "Food Access Research Atlas" )
health_data <- read_excel("/Users/emilybroderick/Desktop/R/STDA/Places.xlsx")

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

library(writexl)
library(knitr)
library(readr)


#Cleaning poverty outliers
poverty_bounds <- quantile(merged$PovertyRate, probs = c(0.025, 0.975), na.rm = TRUE)

# Windsorize poverty manually
merged <- merged %>%
  mutate(
    PovertyRate_new = pmin(
      pmax(PovertyRate, poverty_bounds[1]),
      poverty_bounds[2]
    )
  )

#Creating a Food Insecurity Index
merged <- merged %>%
  mutate(
    food_insecurity_index = rowSums(
      cbind(
        scale(PovertyRate_new),
        scale(LILATracts_1And10),
        scale(LATracts1)
      ),
      na.rm = TRUE
    )
  )

summary(merged$food_insecurity_index)

#Saving food index to excel file for Tableau
install.packages("writexl")
library(writexl)
write_xlsx(merged, "merged_dataset_with_food_index.xlsx")


#General KPIs of Data
install.packages("e1071")
library(e1071)
#Renaming variables
attr(merged$OBESITY_CrudePrev, "label") <- "Obesity Rate"
attr(merged$DIABETES_CrudePrev, "label") <- "Diabetes Rate"
attr(merged$CANCER_CrudePrev, "label") <- "Cancer Rate"
attr(merged$LILATracts_1And10, "label") <- "LILA Rate"
attr(merged$LATracts1, "label") <- "LA Rate"
attr(merged$PovertyRate_new, "label") <- "Poverty Rate"
attr(merged$food_insecurity_index, "label") <- "Food Insecurity Index"
attr(merged$MedianFamilyIncome, "label") <- "Median Income"
attr(merged$TractSNAP, "label") <- "SNAP Participation"

summ_var <- c("OBESITY_CrudePrev", "DIABETES_CrudePrev", "CANCER_CrudePrev", "LILATracts_1And10", "LATracts1", 
              "PovertyRate_new", "food_insecurity_index", "MedianFamilyIncome","TractSNAP")

str(merged[summ_var])


results_df <- data.frame()

for (c in summ_var) {
  column_data <- as.numeric(merged[[c]])
  
  var_label <- ifelse(!is.null(attributes(merged[[c]])$label),
                      attributes(merged[[c]])$label,c)
  
  stats <- data.frame(
    Mean = mean(column_data, na.rm = TRUE),
    SD = sd(column_data, na.rm = TRUE),
    Skew = skewness(column_data, na.rm = TRUE),
    Min = min(column_data, na.rm = TRUE),
    p5 = quantile(column_data, 0.05, na.rm = TRUE),
    p25 = quantile(column_data, 0.25, na.rm = TRUE),
    Median = median(column_data, na.rm = TRUE),
    p75 = quantile(column_data, 0.75, na.rm = TRUE),
    p95 = quantile(column_data, 0.95, na.rm = TRUE),
    Max = max(column_data, na.rm = TRUE)
  )
  
  stats <- round(stats, 2)
  
  results_df <- rbind(results_df, cbind(Variable = var_label, stats))
}

print(results_df)

#creating a table of stats
install.packages("flextable")      # table creation
install.packages("magrittr")       # for the %>% pipe
install.packages("moments")        # skewness
install.packages("officer")        # export to Word

library(officer)
library(moments)
library(flextable)
library(dplyr)


formatted_table <- flextable(results_df) %>%
  set_header_labels(Variable = "Variable",
                    Mean = "Mean",
                    SD = "SD",
                    Skew = "Skewness",
                    Min = "Min",
                    p5 = "P5",
                    p25 = "P25",
                    Median = "Median",
                    p75 = "P75",
                    p95 = "P95",
                    Max = "Max") %>%
  theme_zebra() %>% # Optional: zebra striping for better readability
  align(j = 1, align = "center") %>%
  align(j = 2:11, align = "right") %>%
  fontsize(size = 10) %>%
  border_inner_h(border = fp_border(width = 1)) %>%
  border_outer(border = fp_border(width = 2)) %>%
  set_caption("KPIs of Food Insecurity and Health Outcomes, 2019")


formatted_table

#convert to word
doc <- read_docx()
doc <- body_add_flextable(doc, formatted_table)
print(doc, target = "KPItable.docx")


#Histograms, Scatterplots and Heat Maps
library(ggplot2)

summary(merged$food_insecurity_index)
fi_histo <- ggplot(merged, aes(x = food_insecurity_index)) +
  geom_histogram(bins = 30, fill = "steelblue", color = "black", alpha = .7) + # EB changed the transparency
  geom_vline(xintercept = 0, linetype = "dashed", linewidth = .5) +
  labs(
    x = "Food Insecurity Index",   
    y = "Number of Census Tracts", 
    title = "Histogram of Food Insecurity Index"
  ) +
  theme_minimal()

# Display the plot
print(fi_histo)

# Save the plot as a PNG
ggsave("fi_histogram.png", plot = fi_histo, width = 6, height = 4, dpi = 300)


#Obesity
ggplot(merged, aes(food_insecurity_index, OBESITY_CrudePrev)) +
  geom_point(color = "gray30", alpha = .5) + # EB changed the transparency and color
  geom_smooth(method = "lm") +
  labs(
  x = "Food Insecurity Index",   
  y = "Obesity Rate (%)",       
  title = "Relationship between Food Insecurity and Obesity"
) +
  theme_minimal() # EB added a theme

ggsave("fi_vs_obesity2.png", width = 6, height = 4)


#Diabetes
ggplot(merged, aes(food_insecurity_index, DIABETES_CrudePrev)) +
  geom_point(color = "gray30", alpha = .5) + # EB changed the transparency
  geom_smooth(method = "lm") +
  labs(
    x = "Food Insecurity Index",   
    y = "Diabetes Rate (%)",     
    title = "Relationship between Food Insecurity and Obesity"
  ) +
  theme_minimal()

ggsave("fi_vs_diabetes2.png", width = 6, height = 4)


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
    mean_food_insecurity = mean(food_insecurity_index, na.rm = TRUE),
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
    BINGE_CrudePrev,
    PovertyRate                          # EB replaced cancer and smoking rate with poverty rate
  ) %>%
  rename(                                            # EB changed variable names below
    "Food Insecurity Index" = food_insecurity_index,
    "Obesity Rate" = OBESITY_CrudePrev,
    "Diabetes Rate" = DIABETES_CrudePrev,
    "Binge Eating Rate" = BINGE_CrudePrev,
    "Poverty Rate" = PovertyRate
  )

cor_matrix <- cor(cor_vars, use = "complete.obs")
cor_matrix

cor_melt <- melt(cor_matrix)

heatmap_plot <- ggplot(cor_melt, aes(Var1, Var2, fill = value)) +
  geom_tile(color = "white") +
  scale_fill_gradient2(
    low = "orange", high = "blue", mid = "white", # EB changed to orange to keep consistent with other visuals
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


