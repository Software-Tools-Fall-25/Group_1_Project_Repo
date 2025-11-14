Team 1 Checkpoint 2
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

<img width="2400" height="1800" alt="image" src="https://github.com/user-attachments/assets/149ae829-9503-45bd-8db9-d27995e17fe0" />
<img width="2400" height="1800" alt="image" src="https://github.com/user-attachments/assets/6bc9773f-3e7f-48a9-bc32-2218967d33f3" />
<img width="2400" height="1800" alt="image" src="https://github.com/user-attachments/assets/b59c5742-8b68-49e0-8131-6d8d78bef1d9" />
<img width="1043" height="640" alt="image" src="https://github.com/user-attachments/assets/72277102-69a8-4d52-a3d6-6b5c7b2fceef" />
<img width="1041" height="630" alt="image" src="https://github.com/user-attachments/assets/e24d8b50-641c-42a1-8f40-2744a9f11267" />

<div class='tableauPlaceholder' id='viz1763163451837' style='position: relative'><noscript><a href='#'><img alt='Dashboard 1 ' src='https:&#47;&#47;public.tableau.com&#47;static&#47;images&#47;V_&#47;V_1_STDA_Proj&#47;Dashboard1&#47;1_rss.png' style='border: none' /></a></noscript><object class='tableauViz'  style='display:none;'><param name='host_url' value='https%3A%2F%2Fpublic.tableau.com%2F' /> <param name='embed_code_version' value='3' /> <param name='site_root' value='' /><param name='name' value='V_1_STDA_Proj&#47;Dashboard1' /><param name='tabs' value='no' /><param name='toolbar' value='yes' /><param name='static_image' value='https:&#47;&#47;public.tableau.com&#47;static&#47;images&#47;V_&#47;V_1_STDA_Proj&#47;Dashboard1&#47;1.png' /> <param name='animate_transition' value='yes' /><param name='display_static_image' value='yes' /><param name='display_spinner' value='yes' /><param name='display_overlay' value='yes' /><param name='display_count' value='yes' /><param name='language' value='en-US' /></object></div>                <script type='text/javascript'>                    var divElement = document.getElementById('viz1763163451837');                    var vizElement = divElement.getElementsByTagName('object')[0];                    if ( divElement.offsetWidth > 800 ) { vizElement.style.width='1000px';vizElement.style.height='827px';} else if ( divElement.offsetWidth > 500 ) { vizElement.style.width='1000px';vizElement.style.height='827px';} else { vizElement.style.width='100%';vizElement.style.height='1477px';}                     var scriptElement = document.createElement('script');                    scriptElement.src = 'https://public.tableau.com/javascripts/api/viz_v1.js';                    vizElement.parentNode.insertBefore(scriptElement, vizElement);                </script>


## Generate meaningful summary statistic (KPIs) of the data

## Submit draft of progress at Checkpoint 1 and Checkpoint 2.

## Summarize your findings in a short video presentation.

## Publish a detailed, well formatted markdown report of your analytical story to your GitHub repository.

# Contributions

## Devanae

- Provided the food access data and explained the data/variables included in the dataset
  to determine if we want to use it for the project
- Shared the food access data with team members via email to review
- Submitted project topic to Canvas

## Emily

- Provided the datasets for the health-related data.
- Helped formulate the project topic and description by creating
  questions and ideas for potential directions.
- Initialized goal setting for Checkpoint 1.
- Setup the GitHub Repository.
- Initialized and contributed to this README file.
- Helped orient team members to GitHub.
- Initiated Tableau workbook.
- Joined the two datasets to be used in Tableau.
- Created initial Tableau visualizations.
- Initiated Tableau version upload to Git to collaborate with team.

## Mia

- Created a Google Doc to discuss project topics and dataset information
- Created a project checklist to see team members in progress and completed work items
- Clean and upload health and food datasets to GitHub checkpoint branch
- Created R Script "Dataset Merge.R" to combine files together under code folder
- Generated new csv file for merged dataset under data folder
- Edited ReadMe in checkpoint branch to describe dataset variables and the merge
- Created images of a few plots to store on Git
- Helped orient team members to GitHub

## Laurel

- Linked the merged dataset with R to allow for data manipulation linked directly to any potential changes to the datasets
- Determined different categories of data that could be combined to create a "food insecurity score"
- Utilized the food insecurity score to compare with different health concerns
- Created several plots to show if there is any potential correlation between food insecurity and health concerns to guide further data exploration
- Created images of the remaining plots to store on Git
- Integrated the plot images with the README file

  
