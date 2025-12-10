#libraries
library(readr)
library(dplyr)
library(scales)
library(ggplot2)
library(zoo)
library(lmtest)
library(nortest)

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

#correlation with obesity
obesity_cor <- cor(data$FoodInsecurityScore,data$OBESITY_CrudePrev,use="complete.obs")
print(obesity_cor)

#regression model of obesity
obesity_model <- lm(OBESITY_CrudePrev~FoodInsecurityScore,data=data)
summary(obesity_model)

#obesity plots
ggplot(data, aes(x = FoodInsecurityScore, y = OBESITY_CrudePrev)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  labs(x = "Food Insecurity Score",
       y = "Obesity Crude Prevalence")

plot(obesity_model)

obesity_residuals <- residuals(obesity_model)
hist(obesity_residuals,breaks=100,freq=FALSE,main="Obesity Residuals")

#correlation with diabetes
diabetes_cor <- cor(data$FoodInsecurityScore,data$DIABETES_CrudePrev,use="complete.obs")
print(diabetes_cor)

#regression model of diabetes
diabetes_model <- lm(DIABETES_CrudePrev~FoodInsecurityScore,data=data)
summary(diabetes_model)

#diabetes plots
ggplot(data,aes(x=FoodInsecurityScore,y=DIABETES_CrudePrev))+
  geom_point()+
  geom_smooth(method="lm",se=FALSE,color="red")+
  labs(x="Food Insecurity Score",
       y="Diabetes Crude Prevalence")

plot(diabetes_model)

diabetes_residuals <- residuals(diabetes_model)
hist(diabetes_residuals,breaks=100,freq=FALSE,main="Diabetes Residuals")

#correlation with cancer
cancer_cor <- cor(data$FoodInsecurityScore,data$CANCER_CrudePrev,use="complete.obs")
print(cancer_cor)

#regression model of cancer
cancer_model <- lm(CANCER_CrudePrev~FoodInsecurityScore,data=data)
summary(cancer_model)

#cancer plots
ggplot(data,aes(x=FoodInsecurityScore,y=CANCER_CrudePrev))+
  geom_point()+
  geom_smooth(method="lm",se=FALSE,color="red")+
  labs(x="Food Insecurity Score",
       y="Cancer Crude Prevalence")

plot(cancer_model)

cancer_residuals <- residuals(cancer_model)
hist(cancer_residuals,breaks=100,freq=FALSE,main="Cancer Residuals")

#correlation with smoking
smoking_cor <- cor(data$FoodInsecurityScore,data$CSMOKING_CrudePrev,use="complete.obs")
print(smoking_cor)

#regression model of cancer
smoking_model <- lm(CSMOKING_CrudePrev~FoodInsecurityScore,data=data)
summary(smoking_model)

#cancer plots
ggplot(data,aes(x=FoodInsecurityScore,y=CSMOKING_CrudePrev))+
  geom_point()+
  geom_smooth(method="lm",se=FALSE,color="red")+
  labs(x="Food Insecurity Score",
       y="Smoking Crude Prevalence")

plot(smoking_model)

smoking_residuals <- residuals(smoking_model)
hist(smoking_residuals,breaks=100,freq=FALSE,main="Smoking Residuals")

#correlation with binge eating
binge_cor <- cor(data$FoodInsecurityScore,data$BINGE_CrudePrev,use="complete.obs")
print(binge_cor)

#regression model of binge eating
binge_model <- lm(BINGE_CrudePrev~FoodInsecurityScore,data=data)
summary(binge_model)

#binge eating plots
ggplot(data,aes(x=FoodInsecurityScore,y=BINGE_CrudePrev))+
  geom_point()+
  geom_smooth(method="lm",se=FALSE,color="red")+
  labs(x="Food Insecurity Score",
       y="Binge Eating Crude Prevalence")

plot(binge_model)

binge_residuals <- residuals(binge_model)
hist(binge_residuals,breaks=100,freq=FALSE,main="Binge Eating Residuals")

