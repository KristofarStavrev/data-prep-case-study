# Data Preparation and Visualization Case Study

## Project Description

The idea for the project originates from an university class case study given by a private wealth managemen company. The main goal of the project was to create a way to measure key performance indicators of the company website activities using automated data cleaning and analysis techniques following the [CRISP-DM](https://www.the-modeling-agency.com/crisp-dm.pdf) methodology. The final result was the creation of a dashboard with charts containing valuable insights about the customers of the company, which can further help in steering the marketing efforts in the right direction.

The project was developed using R and R Markdown in RStudio.

Libraries used:
- stringr
- lubridate
- R.utils
- plyr
- dplyr
- flexdashboard
- DT
- ggplot2
- plotly
- reshape2
- ggpubr

## Data Understanding
The data that this project uses is stored in access log files with each file representing a separate day and containing a complete list of all requests made to the web server. The exact structure of the information and all the different columns can be seen in the figure below.

### Image 1: Structure of the raw data

![alt text](https://github.com/KrythonS/data-prep-case-study/blob/main/images/image.png?raw=true)

The main intention was to create an automated, scalable, and long-term solution which allows for an easy way to include new data in the the dashboard of charts. For this purpose, it was decided that the best approach would be to create an artificial database file under the format of CSV that would contain the entirety of the cleaned and filtered data.

Every time new log files are downloaded from the server they can simply be placed in a specific location and the script would automatically clean, organise, and append to the CSV database. The script would then proceed to update all the charts present on the dashboard.

## To run the program

## Design of the dashboard

### 
