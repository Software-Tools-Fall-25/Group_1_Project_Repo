Team 1 Final Project: PUT PROJECT TITLE HERE
================
Devanae Allen, Emily Broderick, Mia Raineri, Laurel Urwick

# Introduction

Our team analyzed how disparities in food access relate to variation in community health outcomes across the United States with a focused comparison between national trends and those observed in Massachusetts. By using census-tract level data from the CDC PLACES dataset **(Include citation)** and the USDA Food Access Research Atlas **(Include citation)**, we examined these relationships at the national, state, and even the city level. Health outcomes studied include rates of obesity, diabetes, and binge eating, while the Food Insecurity Index considers _______, ______, and _______.

Our main decision maker is the Massachusetts Department of Public Health (DPH), whose mission is to “promote and protect health and wellness and prevent injury and illness for all people, prioritizing racial equity in health by improving equitable access to quality public health and health care services and partnering with communities most impacted by health inequities and structural racism” (Mass.gov). By analyzing food access and health outcomes, and comparing Massachusetts to national trends, our research supports identifying where resources should be directed, such as toward food programs, grocery development, and other community health efforts. These findings can help guide targeted policy recommendations that better address food insecurity and related health challenges for key populations in Massachusetts.

# Data Summary

To understand how food insecurity affects Massachusetts residents, our group looked to two reputable sources:

1) USDA Food Access Research Atlas
This dataset contains approximately 144 variables on food access, geographic indicators, and socio-economic indicators. The dataset follows the Census tract, meaning that it contains observations for each county in the United States in 2019– the last time the Food Atlas was updated. Some variables of interest include the low income-low access (LILA) tracts, low-access (LA) tracts, poverty rate, SNAP participation, income, and race descriptors.

3) CDC’s PLACES 500 Cities
This dataset contains 40 specific chronic disease indicators, behaviors, and preventative care measures, providing more local data to improve health care outcomes. The dataset also follows the Census tract, which allows for easy merging of data and comparison between city, state, and national levels. Some variables of interest include chronic health conditions like obesity, diabetes, and binge eating.

When we say “census-tract level data,” we are referring to the way in which the data was collected across the United States by the Census Bureau. Census tracts create statistical neighborhoods that are small, relatively permanent geographic areas (Lampe). Therefore, when data is collected in this way, we are able to track changes over time to the same geographic areas, allowing for insight into these changes (i.e. demographics, income, poverty, housing, etc).

  - **(name of final dataset)**

## Analytic Tools

### R and RStudio

We used R to clean and merge the datasets and create some visualizations. The datasets were cleaned to remove raw counts, irrelevant variables to our analysis, and unnecessary, missing, or NA values in order to reduce the final file size below GitHub’s 50 MB limit. Census tract identifiers (CensusTract and TractFIPS) were used to merge the datasets. **(Very briefly mention which visualizations were created in R)**

### Tableau

We used Tableau to create additional visualizations using the merged dataset from R. We found that it was a useful tool for producing choropleths at the state and national level, as well as scatterplots. **(Feel free to edit with any other visualizations we end up using in Tableau)**

### Tableau Public Links

These dashboards include our interactive visuals on food insecurity and health outcomes, designed for decision makers to explore key trends in National vs. State-level trends.

[Physical Health and Poverty](https://public.tableau.com/app/profile/emily.broderick/viz/PhysicalHealthandPoverty/PhysicalHealthandPoverty?publish=yes)


# Analytic Overview

This section provides an analytical overview of a few variables of interest in both datasets. Basic summary statistics will be discussed below for the steps taken to construct a Food Security Index as well as key performance indicators (KPIs). We will also explore various relationships between food access and chronic health condition variables by providing basic scatterplots and correlation heat maps. We utilized R to conduct most of our statistical analyses.

## 1. Food Insecurity Index

The food security index was created based off of previous research in the field, which identify risk factors by the four pillars of food security: availability, access, utilization and stability (World Bank Group). Examples of risk factors include household resources  (income, poverty level), food access (transportation, food assistance like SNAP), and demographics (race, disability). Since we have access to many of these variables, we created an index that specifically speaks to the question of access from an economic and geographic perspective:
  - Poverty rate: represents the percentage of individuals in a census tract living below federal poverty threshold. To reduce the influence of extreme outliers, the poverty rate was windsorized at the upper and lower bounds (95% CI)
  - Low income low access (LILA) 1 and 10 mile tract: this tract simultaneously meets the low income criteria and low access to grocery stores for urban (1 mile) and rural (10 mile) populations. 
  - Low access (LA) 1 mile tract: this tract at the 1-mile threshold identifies tracts where food access is independent from the low income indicator.

Variables like income, race, and transportation can be leveraged independently from the index itself, as you will notice in our visualizations and regression analysis.

To create this element in R, we combined our variables using the scale() function, which standardizes numeric data through Z-score normalization. Therefore, the mean of the data is centered around zero and the standard deviation is scaled to one. This was our approach for the index since we are comparing variables on different scales, units, and ranges. It also makes the index much easier to interpret with regards to its practicality. Here is the code in R:

```{r}
# Creating a Food Insecurity Index
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
```
## 2. Key Summary Statistics (KPIs)

Below you will find a descriptive statistics table that provides a high-level overview of our main variables. We can infer a few things about our health outcomes, food access variables, and socio-economic indicators by studying the results.

**(insert stats table)**

### Health Outcomes

The obesity rate has a mean of 30.5% and a standard deviation of 8.2, meaning that obesity can vary greatly across tracts but clusters at the 30% mark. The skew of 0.43 is a low positive skew with only a few outliers at the top pulling up the mean. The diabetes rate reports lower values with a mean of 10.8% and standard deviation of 4.3, but a moderate right skew (0.93) tells us it is more disproportionate than obesity rates. Cancer reports a high skew value (1.29). For instance, the 95th percentile tells us the tract can see a 9% cancer rate, while the average is 5.65%.

### Food Access

The LILA rate has a mean of 0.13, telling us that only 13% of tracts can be classified as “low income, low access.” On the other hand, the LA rate is 0.34, meaning that 34% of tracts, urban and rural, can be classified as low access. Therefore, we can see the food insecurity picture a little bit more clearly, as food access may not be completely described by lack of resources or access alone. The food insecurity index is uniquely situated at a mean of 0 and has a standard deviation of 2.05. A skew of 1.47 tells us that a small number of tracts have very high food insecurity, and the negative values in the distribution tell us the tracts that have levels below the average. Understand that the values for the index indicate how many standard deviations above or below the tract is from the average.

### Socioeconomic Indicators

Poverty rate has a mean of 14.9% and a standard deviation of 11, telling us that there are some tracts with high poverty rates (max is 45%) pulling up the mean. Median income is around $77,000 but with a high skew of 1.45, suggesting large income inequality in the US. In general, there is a wide distribution of people represented in the data, which we hope contributes to meaningful results in understanding the interplay between food, health, and poverty.

## 3. Exploring relationships between variables

To quickly check how the food insecurity index compares to our KPIs, let’s visualize what the distribution of our index looks like and then use a scatterplot to measure the relationship to obesity, diabetes, and binge eating. 

### Histogram of Food Insecurity Index

<img src="images/fi_histogram.png" />

*Note how histogram has low values at 2.5 mark. High skew variable.

### Scatterplot of Food Insecurity and Diabetes

<img src="images/Scatterplot_FIS_Diabetes.png" />

This scatterplot reflects the relationship between food insecurity and the prevalence of diabetes nationally. There is a positive correlation between food insecurity score and diabetes rate. As the food insecurity score increases, so does the prevalence of diabetes. Looking at Massachusetts, specifically, it falls at the lower end of food insecurity score (~0.2), and around the middle for diabetes rate (~9%). 

### Scatterplot of Food Insecurity and Obesity

<img src="images/Scatterplot_FIS_Obesity.png" />

This scatterplot reflects the relationship between food insecurity and the rate of obesity nationally. There is a positive correlation between food insecurity score and obesity rate. As the food insecurity score increases, so does the prevalence of obesity. Looking at Massachusetts, specifically, it falls at the lower end of food insecurity score (~0.2), and around the low-middle for obesity rate (~28%). 

### Scatterplot of Food Insecurity and Binge Eating

<img src="images/Scatterplot_FIS_BingeEating.png" />

This scatterplot reflects the relationship between food insecurity and the prevalence of binge eating nationally. There is a negative correlation between food insecurity score and binge eating. As the food insecurity score increases, the prevalence of binge eating decreases. Looking at Massachusetts, specifically, it falls at the lower end of food insecurity score (~0.2), and around the middle for binge eating rate (~20%). 

### Correlation Heat Map of KPIs

# Strategic Insights

To fully grasp the scope of this project, we consolidated all of our findings into three (3) strategic insights. Therefore, you will fully understand the biggest takeaways from this project without having to necessarily be an expert on this topic.


## 1. The Structural Risks of Food Insecurity on National and State Levels

The structural risks of food insecurity include variables that limit access to food based off an individual’s resources. We measure structural risks by looking at family income, poverty levels, proximity to grocery stores, as well as access to a vehicle. A person can be both low income and low access, or they may only be described as low access due to their living circumstances.

Our research found that it is very important to distinguish between the Low Income Low Access (LILA) variables as opposed to the Low Access (LA) Variables.

 ## 2. Chronic Health Conditions Stem from Food Insecurity


## 3. Racial Equity in Health Remains Intact in Massachusetts


# Policy Recommendations

# Sources




# Conclusion




  
