Team 1 Checkpoint 1
================
Devanae Allen, Emily Broderick, Mia Raineri, Laurel Urwick

# Progress

## Propose a Research Topic

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

## Create a GitHub repository and establish best practices for team collaboration.

Our GitHub repository has been established with editing rights limited
to team members, while viewing rights are open to the public.

One challenge we faced was making sure all members of the team had
access to the repository. Another challenge was orienting ourselves to
the GitHub interface. Spending time this week collaborating via GitHub
has started to increase our familiarity with the site.

## Demonstrate merging of multiple data sources

First, we looked at a dataset from the USDA Food Access Research Atlas. The dataset contains approximately 144 variables on food access, geographic indicators, and socio-economic indicators. Importantly, the dataset follows the Census tract, meaning that we have observations for each county in the United States in 2019 - which is the last time the Food Atlas was updated. Some raw count or irrelevant variables were removed from the dataset in order to get below the 50 MB threshold for Git.

Secondly, we looked at a dataset from the CDC called PLACES 500 Cities, which is also Census tract data. This allows for easy merging of data and comparison on many different levels, whether it be city, state, or national. The PLACES data contains variables on chronic conditions like obesity, diabetes, high blood pressure and much more.

While both datasets have geographic codes, the PLACES dataset is missing a few of the county specific indicators that the Food Atlas Includes. Therefore, separated the geographic code into sections that merge the data when the County, State, and Tract Codes all match. Therefore, some observations will be dropped if there was no health data for a specific area tracked in the Food Atlas.

## Visualize data using Tableau, R, Python, or a combination

## Generate meaningful summary statistic (KPIs) of the data

## Submit draft of progress at Checkpoint 1 and Checkpoint 2.

## Summarize your findings in a short video presentation.

## Publish a detailed, well formatted markdown report of your analytical story to your GitHub repository.

# Contributions

## Devanae

- 

## Emily

- Provided the datasets for the health-related data.
- Helped formulate the project topic and description by creating
  questions and ideas for potential directions.
- Initialized goal setting for Checkpoint 1.
- Setup the GitHub Repository.
- Initialized and contributed to this README file.

## Mia

- Created a Google Doc to discuss project topics and dataset information
- Created a project checklist to see team members in progress and completed work items
- Clean and upload health and food datasets to GitHub checkpoint branch
- Created R Script "Dataset Merge.R" to combine files together under code folder
- Generated new csv file for merged dataset under data folder
- Edited ReadMe in checkpoint branch to describe dataset variables and the merge

## Laurel

- 
