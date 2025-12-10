# Health Outcomes Scatterplots
# Laurel Urwick and Emily Broderick

#libraries
library(readr)
library(dplyr)
library(scales)
library(ggplot2)

# Pulling in and reading data
url <- "https://raw.githubusercontent.com/Software-Tools-Fall-25/Group_1_Project_Repo/9c9a23f40b6a848c51bc95c208776a6c8491c1f0/merged_dataset.csv"
data <- read.csv(url)
head(data)
colnames(data)
numeric_cols <- c("TractLOWI", "LILATracts_1And10", "PovertyRate", "OBESITY_CrudePrev", "DIABETES_CrudePrev", "PHLTH_CrudePrev", "MHLTH_CrudePrev", "CSMOKING_CrudePrev")
data[numeric_cols] <- lapply(data[numeric_cols], as.numeric)

# Creating a food insecurity score
data$TractLOWI_scaled <- rescale(data[["TractLOWI"]], to = c(0,1))
data$LILATracts_scaled <- rescale(data[["LILATracts_1And10"]], to = c(0,1))
data$PovertyRate_scaled <- rescale(data[["PovertyRate"]], to = c(0,1))
data$FoodInsecurityScore <- data$TractLOWI_scaled + data$LILATracts_scaled + data$PovertyRate_scaled

# Create dataset for MA graphs
data_ma <- data %>%
  filter(State == "Massachusetts")

# National Health Outcomes vs. FIS - MA Focus
# Comparing food insecurity and obesity
analysis_data_obesity <- data_ma %>%
  # Group_by(State) %>%
  summarise(
    AvgFoodInsecurity = mean(FoodInsecurityScore, na.rm = TRUE),
    AvgObesity = mean(OBESITY_CrudePrev, na.rm = TRUE)
  )


plot1 <- ggplot(analysis_data_obesity,
                aes(x = AvgFoodInsecurity,
                    y = AvgObesity)) +
  geom_point(aes(color = ifelse(State == "Massachusetts", "MA", "Other")),
             size = 2, alpha = 0.7) +
  scale_color_manual(values = c("MA" = "orange", "Other" = "black"), guide = FALSE) +
  geom_smooth(method = "lm", color = "blue", se = TRUE) +
  geom_text(data = subset(analysis_data_diabetes, State == "Massachusetts"),
            aes(label = State),
            vjust = -1, size = 3, color = "orange") +
  labs(
    title = "Relationship Between Food Insecurity and Obesity by State",
    x = "Average Food Insecurity Score",
    y = "Average Obesity Prevalence (%)"
  ) +
  theme_minimal()

plot1

ggsave("images/FoodInsecurity_Obesity.png", plot = plot1, width = 8, height = 6, dpi = 300)

# Comparing food insecurity and diabetes
analysis_data_diabetes <- data %>%
  group_by(State) %>%
  summarise(
    AvgFoodInsecurity = mean(FoodInsecurityScore, na.rm = TRUE),
    AvgDiabetes = mean(DIABETES_CrudePrev, na.rm = TRUE)
  )

plot2 <- ggplot(analysis_data_diabetes,
                aes(x = AvgFoodInsecurity,
                    y = AvgDiabetes)) +
  geom_point(aes(color = ifelse(State == "Massachusetts", "MA", "Other")),
             size = 2, alpha = 0.7) +
  scale_color_manual(values = c("MA" = "orange", "Other" = "black"), guide = FALSE) +
  geom_smooth(method = "lm", color = "blue", se = TRUE) +
  geom_text(data = subset(analysis_data_diabetes, State == "Massachusetts"),
            aes(label = State),
            vjust = -1, size = 3, color = "orange") +
  labs(
    title = "Relationship Between Food Insecurity and Diabetes by State",
    x = "Average Food Insecurity Score",
    y = "Average Diabetes Prevalence (%)"
  ) +
  theme_minimal()

plot2

ggsave("images/FoodInsecurity_Diabetes.png", plot = plot2, width = 8, height = 6, dpi = 300)


# Comparing food insecurity and binge eating
analysis_data_binge <- data %>%
  group_by(State) %>%
  summarise(
    AvgFoodInsecurity = mean(FoodInsecurityScore, na.rm = TRUE),
    AvgBinge = mean(BINGE_CrudePrev, na.rm = TRUE)
  )

plot3 <- ggplot(analysis_data_binge,
                aes(x = AvgFoodInsecurity,
                    y = AvgBinge)) +
  geom_point(aes(color = ifelse(State == "Massachusetts", "MA", "Other")),
             size = 2, alpha = 0.7) +
  scale_color_manual(values = c("MA" = "orange", "Other" = "black"), guide = FALSE) +
  geom_smooth(method = "lm", color = "blue", se = TRUE) +
  geom_text(data = subset(analysis_data_binge, State == "Massachusetts"),
            aes(label = State),
            vjust = -1, size = 3, color = "orange") +
  labs(
    title = "Relationship Between Food Insecurity and Binge Eating by State",
    x = "Average Food Insecurity Score",
    y = "Average Binge Eating Prevalence (%)"
  ) +
  theme_minimal()

plot3

ggsave("images/FoodInsecurity_Binge.png", plot = plot3, width = 8, height = 6, dpi = 300)


# Massachusetts Health Outcomes vs. FIS

plot4 <- ggplot(data_ma,
                aes(x = FoodInsecurityScore,
                    y = OBESITY_CrudePrev)) +
  geom_point(size = 2, alpha = 0.7) +
  #scale_color_manual(values = c("MA" = "orange", "Other" = "black"), guide = FALSE) +
  geom_smooth(method = "lm", color = "blue", se = TRUE) +
  #geom_text(data = subset(analysis_data_obesity, State == "Massachusetts"),
  #aes(label = State),
  #vjust = -1, size = 3, color = "orange") +
  labs(
    title = "Relationship Between Food Insecurity and Obesity in Massachusetts",
    x = "Food Insecurity Score",
    y = "Obesity Prevalence (%)"
  ) +
  theme_minimal()

plot4


plot5 <- ggplot(data_ma,
                aes(x = FoodInsecurityScore,
                    y = DIABETES_CrudePrev)) +
  geom_point(size = 2, alpha = 0.7) +
  #scale_color_manual(values = c("MA" = "orange", "Other" = "black"), guide = FALSE) +
  geom_smooth(method = "lm", color = "blue", se = TRUE) +
  #geom_text(data = subset(analysis_data_obesity, State == "Massachusetts"),
  #aes(label = State),
  #vjust = -1, size = 3, color = "orange") +
  labs(
    title = "Relationship Between Food Insecurity and Diabetes in Massachusetts",
    x = "Food Insecurity Score",
    y = "Diabetes Prevalence (%)"
  ) +
  theme_minimal()

plot5


plot6 <- ggplot(data_ma,
                aes(x = FoodInsecurityScore,
                    y = BINGE_CrudePrev)) +
  geom_point(size = 2, alpha = 0.7) +
  #scale_color_manual(values = c("MA" = "orange", "Other" = "black"), guide = FALSE) +
  geom_smooth(method = "lm", color = "blue", se = TRUE) +
  #geom_text(data = subset(analysis_data_obesity, State == "Massachusetts"),
  #aes(label = State),
  #vjust = -1, size = 3, color = "orange") +
  labs(
    title = "Relationship Between Food Insecurity and Binge Eating in Massachusetts",
    x = "Food Insecurity Score",
    y = "Binge Eating Prevalence (%)"
  ) +
  theme_minimal()

plot6
