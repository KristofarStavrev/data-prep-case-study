# Data Preparation and Visualization Case Study

## Project Description

The idea for the project originates from a university class case study given by a private wealth management company. The main goal of the project was to create a way to measure key performance indicators of the company website activities using automated data cleaning and analysis techniques following the [CRISP-DM](https://www.the-modeling-agency.com/crisp-dm.pdf) methodology. The final result was the creation of a dashboard with charts containing valuable insights about the customers of the company, which can further help in steering the marketing efforts in the right direction.

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

The main intention was to create an automated, scalable, and long-term solution which allows for an easy way to include new data in the dashboard of charts. For this purpose, it was decided that the best approach would be to create an artificial database file under the format of CSV that would contain the entirety of the cleaned and filtered data.

Every time new log files are downloaded from the server they can simply be placed in a specific location and the script would automatically clean, organize, and append to the CSV database. The script would then proceed to update all the charts present on the dashboard.

## To run the program

A software is not particularly useful unless the customer can access its results. Detailed instructions and steps for deploying the code can be found below.

1. Install the required dependencies (list of libraries can be found above)
2. Place raw data into the `logs` folder (sample of raw data can be found in the logs folder)
3. Open the file `dashboard.Rmd` with RStudio and press the `Knit` button
4. Wait for the script to execute (can take a significant amount of time if large amounts of data are being processed)
5. You can view the dashboards by opening `dashboard.html`

## Design of the dashboard

### Image 2: Dashboard Overview Section

![alt text](https://github.com/KrythonS/data-prep-case-study/blob/main/images/Overview.png?raw=true)

### Image 3: Dashboard Blog Section

![alt text](https://github.com/KrythonS/data-prep-case-study/blob/main/images/Blog.png?raw=true)
