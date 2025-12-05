Team 1 Checkpoint 2
================
Devanae Allen, Emily Broderick, Mia Raineri, Laurel Urwick

# Progress

# Propose a Research Topic

**Project Topic:** Exploring the relationship between food access and
health outcomes across a variety of geographic levels

**Project Description:** Our group wants to investigate how disparities
in food access related to differences in community health outcomes
across the United States. Using census-tract level data from the CDC
PLACES dataset and the USDA Food Access Research Atlas, we will look at
these relationships on a variety of levels - national, state, and even
the city level. Measures of food accessibility include proximity to
grocery stores (which help identify food deserts) and low-income
population indicators. Health outcomes studied are rates of obesity,
diabetes, and mental health levels. We hope to identify geographic
patterns or correlations that explain the impact of food insecurity on
public health.

**Proposed Project Focus:** Compare Massachusetts to National average across different variables in health and food insecurity. Conduct a correlation analysis of select variables from the food insecurity and health datasets.

# Create a GitHub repository and establish best practices for team collaboration.

Our GitHub repository has been established with editing rights limited
to team members, while viewing rights are open to the public.

One challenge we faced was making sure all members of the team had
access to the repository. Another challenge was orienting ourselves to
the GitHub interface. Spending time this week collaborating via GitHub
has started to increase our familiarity with the site. Another challenge has been working around the file size limitations of GitHub and ensuring that we are all working on the most updated files created. 

# Demonstrate merging of multiple data sources

First, we looked at a dataset from the USDA Food Access Research Atlas. The dataset contains approximately 144 variables on food access, geographic indicators, and socio-economic indicators. Importantly, the dataset follows the Census tract, meaning that we have observations for each county in the United States in 2019 - which is the last time the Food Atlas was updated. Some raw count or irrelevant variables were removed from the dataset in order to get below the 50 MB threshold for Git.

Secondly, we looked at a dataset from the CDC called PLACES 500 Cities, which is also Census tract data. This allows for easy merging of data and comparison on many different levels, whether it be city, state, or national. The PLACES data contains variables on chronic conditions like obesity, diabetes, high blood pressure and much more.

While both datasets have geographic codes, the PLACES dataset is missing a few of the county specific indicators that the Food Atlas Includes. Therefore, separated the geographic code into sections that merge the data when the County, State, and Tract Codes all match. Therefore, some observations will be dropped if there was no health data for a specific area tracked in the Food Atlas.

# Visualize data using Tableau, R, Python, or a combination

## Link to Tableau workbooks:
**V.1:** https://public.tableau.com/shared/2D23R7SYN?:display_count=n&:origin=viz_share_link 

**V.2:** https://public.tableau.com/views/V_2_STDA_Proj/Dashboard2?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link

**V.3:** https://public.tableau.com/views/V_3_STDA_Proj/Dashboard3?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link

**V.4:** https://public.tableau.com/views/V_4_STDA_Proj/Dashboard1?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link
**V.4.1:** https://public.tableau.com/views/V_4_1_STDA_Proj/Dashboard1?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link
Let me know which you guys prefer. 4.1 can toggle between urban vs rural but you also have to manually toggle between state/county/city/tract views, it doesn't change for you as you zoom in. The slope calculation that populates the KPI section is still wrong in both versions.

## R Prelim Visuals:
<img width="2400" height="1800" alt="image" src="https://github.com/user-attachments/assets/149ae829-9503-45bd-8db9-d27995e17fe0" />
<img width="2400" height="1800" alt="image" src="https://github.com/user-attachments/assets/6bc9773f-3e7f-48a9-bc32-2218967d33f3" />
<img width="2400" height="1800" alt="image" src="https://github.com/user-attachments/assets/b59c5742-8b68-49e0-8131-6d8d78bef1d9" />
<img width="1043" height="640" alt="image" src="https://github.com/user-attachments/assets/72277102-69a8-4d52-a3d6-6b5c7b2fceef" />
<img width="1041" height="630" alt="image" src="https://github.com/user-attachments/assets/e24d8b50-641c-42a1-8f40-2744a9f11267" />

# Generate meaningful summary statistic (KPIs) of the data

This section provides an analytical overview of a few variables of interest between both datasets. Basic summary statistics will be discussed below for key performance indicators (KPIs) as well as the steps taken to construct a composite Food Security Index. Finally, we will explore various relationships between food access and chronic health condition variables.

## 1. Summary Statistics (KPIS)

To develop a high-level understanding of our merged dataset, we provide summary statistics that describe obesity, poverty, and food access across the Census tracts. Using the dplyr package, the following KPIs were computed:

- Mean, median, and SD of obesity prevalence (OBESITY_CrudePrev)
- Mean, median, and SD of obesity prevalence (DIABETES_CrudePrev)
- Percent of tracts classified as LILA (Low Income and Low Access)
- Percent of tracts Low Access at 1 mile (USDA classified food dessert <1 mile)
- Mean poverty rate across all tracts

  <img width="730" height="828" alt="kpi_table" src="https://github.com/user-attachments/assets/e7a308b4-8d54-4b92-b7bd-107cb13fc3c5" />

These KPIs provide baseline indicators of the population health and food access conditions across the US.

## 2. Food Insecurity Index Creation

Our dataset did not contain a food insecurity index, so we generated our own index. To capture the many different layers that contribute to a traditional food insecurity score, we combined the follow four standardized variables:
- Poverty Rate
- Low Income Low Access designation (LILATracts1_and10 accounts for urban and rural insecurity)
- SNAP participation rates
- Low Access share of population

Each variable was standardized using scale() and the index is defined as the sum of the variables z-scores

```
# Index Code from R
food_insecurity_index = 
    scale(PovertyRate) +
    scale(LILATracts_1And10) +
    scale(TractSNAP) +
    scale(lapop1share)
```
The index is a continuous metric that shows higher values where we may expext higher food insecurity.

## 3. Relationships between FI Index and Chronic Health Conditions

To quickly check how the food insecurity index compares to our KPIs, we can use a scatteplot of FI index on our obesity measure and include a fitted line.

```
ggplot(merged, aes(food_insecurity_index, OBESITY_CrudePrev)) +
  geom_point() +
  geom_smooth(method = "lm")
```
The visualization proves that as the FI index increases, obesity is also expected to increase on average. A correlation analysis of FI against obesity and diabetes also proved to show similar findings (correlations of 0.67 and 0.56 respectively).

<img width="1800" height="1200" alt="fi_vs_obesity" src="https://github.com/user-attachments/assets/31202982-5c31-4e26-8d92-2cbe48445574" />

To provide a more comprehensive snapshot of how the index relates to other chronic conditions, we created a correlation heat map to show us the strength of relationship between certain variables over others. This can help guide which variables we may want to take a deeper look at later on.

<img width="2100" height="1800" alt="correlation_heatmap" src="https://github.com/user-attachments/assets/c5c8c3d2-b1b1-4aa4-93db-b477ddd0ecf2" />


## 4. Identifying Food Insecurity Hotspots for Analysis

To best understand the interplay between food insecurity and health conditions, we found it may be helpful to see whether there are differences between quintiles within the data. For instance, we can identify which areas in the US are least to more food insecure and potentially pintpoint certain factors that make an area more suceptible. 

```
fi_quintile = ntile(food_insecurity_index, 5)
```
Quintile 1 represents an area with low food insecurity and quintile 5 represents the highest. We will use this variable for further analysis within Tableau's mapping feature and compare health outcomes.

# Submit draft of progress at Checkpoint 1 and Checkpoint 2.

Drafts have been submitted at both checkpoints.

# Summarize your findings in a short video presentation.

# Publish a detailed, well formatted markdown report of your analytical story to your GitHub repository.



  
