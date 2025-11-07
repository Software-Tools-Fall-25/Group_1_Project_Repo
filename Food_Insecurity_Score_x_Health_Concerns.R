# Checkpoint 1 Markdown

#libraries
library(readr)
library(dplyr)
library(scales)
library(ggplot2)

#pulling in and reading data
url <- "https://raw.githubusercontent.com/Software-Tools-Fall-25/Group_1_Project_Repo/9c9a23f40b6a848c51bc95c208776a6c8491c1f0/merged_dataset.csv"
data <- read_csv(url)
head(data)
colnames(data)
numeric_cols <- c("TractLOWI", "LILATracts_1And10", "PovertyRate", "OBESITY_CrudePrev", "DIABETES_CrudePrev", "PHLTH_CrudePrev", "MHLTH_CrudePrev", "CSMOKING_CrudePrev")
data[numeric_cols] <- lapply(data[numeric_cols], as.numeric)

#creating a food insecurity score
data$TractLOWI_scaled <- rescale(data[["TractLOWI"]], to = c(0,1))
data$LILATracts_scaled <- rescale(data[["LILATracts_1And10"]], to = c(0,1))
data$PovertyRate_scaled <- rescale(data[["PovertyRate"]], to = c(0,1))
data$FoodInsecurityScore <- data$TractLOWI_scaled + data$LILATracts_scaled + data$PovertyRate_scaled

#comparing food insecurity and obesity
analysis_data_obesity <- data %>%
  group_by(State) %>%
  summarise(
    AvgFoodInsecurity = mean(FoodInsecurityScore, na.rm = TRUE),
    AvgObesity = mean(OBESITY_CrudePrev, na.rm = TRUE)
  )
plot1 <- ggplot(analysis_data_obesity, aes(x=AvgFoodInsecurity, y=AvgObesity, label=State)) +
  geom_point(color="darkred", size=3, alpha=0.7) +
  geom_smooth(method="lm", color="blue", se=TRUE) +
  geom_text(vjust=-0.5, size=3) +
  labs(
    title = "Relationship Between Food Insecurity and Obesity by State",
    x = "Average Food Insecurity Score",
    y = "Average Obesity Prevalence (%)"
  ) +
  theme_grey()


ggsave("images/FoodInsecurity_Obesity.png", plot = plot1, width = 8, height = 6, dpi = 300)

#comparing food insecurity and diabetes
analysis_data_diabetes <- data %>%
  group_by(State) %>%
  summarise(
    AvgFoodInsecurity = mean(FoodInsecurityScore, na.rm = TRUE),
    AvgDiabetes = mean(DIABETES_CrudePrev, na.rm = TRUE)
  )
plot2 <- ggplot(analysis_data_diabetes, aes(x=AvgFoodInsecurity, y=AvgDiabetes, label=State)) +
  geom_point(color="darkred", size=3, alpha=0.7) +
  geom_smooth(method="lm", color="blue", se=TRUE) +
  geom_text(vjust=-0.5, size=3) +
  labs(
    title = "Relationship Between Food Insecurity and Diabetes by State",
    x = "Average Food Insecurity Score",
    y = "Average Diabetes Prevalence (%)"
  ) +
  theme_grey()


ggsave("images/FoodInsecurity_Diabetes.png", plot = plot2, width = 8, height = 6, dpi = 300)


#comparing food insecurity and smoking
analysis_data_smoking <- data %>%
  group_by(State) %>%
  summarise(
    AvgFoodInsecurity = mean(FoodInsecurityScore, na.rm = TRUE),
    AvgSmoking = mean(CSMOKING_CrudePrev, na.rm = TRUE)
  )
plot3 <- ggplot(analysis_data_smoking, aes(x=AvgFoodInsecurity, y=AvgSmoking, label=State)) +
  geom_point(color="darkred", size=3, alpha=0.7) +
  geom_smooth(method="lm", color="blue", se=TRUE) +
  geom_text(vjust=-0.5, size=3) +
  labs(
    title = "Relationship Between Food Insecurity and Smoking by State",
    x = "Average Food Insecurity Score",
    y = "Average Smoking Prevalence (%)"
  ) +
  theme_grey()


ggsave("images/FoodInsecurity_Smoking.png", plot = plot3, width = 8, height = 6, dpi = 300)


#comparing food insecurity and poor physical health
analysis_data_physhealth <- data %>%
  group_by(State) %>%
  summarise(
    AvgFoodInsecurity = mean(FoodInsecurityScore, na.rm = TRUE),
    AvgPhysical = mean(PHLTH_CrudePrev, na.rm = TRUE)
  )
ggplot(analysis_data_physhealth, aes(x=AvgFoodInsecurity, y=AvgPhysical, label=State)) +
  geom_point(color="darkred", size=3, alpha=0.7) +
  geom_smooth(method="lm", color="blue", se=TRUE) +
  geom_text(vjust=-0.5, size=3) +
  labs(
    title = "Relationship Between Food Insecurity and Poor Physical Health by State",
    x = "Average Food Insecurity Score",
    y = "Average Poor Physical Health Prevalence (%)"
  ) +
  theme_minimal()

#comparing food insecurity and poor mental health
analysis_data_menhealth <- data %>%
  group_by(State) %>%
  summarise(
    AvgFoodInsecurity = mean(FoodInsecurityScore, na.rm = TRUE),
    AvgMental = mean(MHLTH_CrudePrev, na.rm = TRUE)
  )
ggplot(analysis_data_menhealth, aes(x=AvgFoodInsecurity, y=AvgMental, label=State)) +
  geom_point(color="darkred", size=3, alpha=0.7) +
  geom_smooth(method="lm", color="blue", se=TRUE) +
  geom_text(vjust=-0.5, size=3) +
  labs(
    title = "Relationship Between Food Insecurity and Poor Mental Health by State",
    x = "Average Food Insecurity Score",
    y = "Average Poor Mental Health Prevalence (%)"
  ) +
  theme_minimal()
