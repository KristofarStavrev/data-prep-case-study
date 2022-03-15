# Load libraries ----
library(lubridate)
library(dplyr)

# Import data ----
rm(list=ls())
setwd(paste(dirname(rstudioapi::getSourceEditorContext()$path),"/db",sep=""))

csv_data=read.csv("db_raw_data.csv", stringsAsFactors = F, na.strings = c("NA", "", " "))

# Check the class of each vector from the data frame and make necessary corrections
aux_table = data.frame(nm=names(csv_data), cl=sapply(csv_data, class), nas=colSums(is.na(csv_data)))
csv_data$Date = ymd(csv_data$Date)
aux_table = data.frame(nm=names(csv_data), cl=sapply(csv_data, class), nas=colSums(is.na(csv_data)))
rm(aux_table)

# Aggregate data ----

# Daily visits
daily_visits = csv_data %>% group_by(Date) %>% summarise(total_visits=n(), distinct_visits=n_distinct(IP))
daily_visits = as.data.frame(daily_visits)
names(daily_visits)[2] = "Total Visits"
names(daily_visits)[3] = "Distinct Visits"

# Weekly visits
weekly_visits = csv_data %>% group_by(Week=paste(Week, Year, sep="-")) %>% summarise(total_visits=n(), distinct_visits=n_distinct(IP))
weekly_visits = as.data.frame(weekly_visits)
names(weekly_visits)[2] = "Total Visits"
names(weekly_visits)[3] = "Distinct Visits"

# Monthly visits
monthly_visits = csv_data %>% group_by(Month=paste(Month, Year, sep="-")) %>% summarise(total_visits=n(), distinct_visits=n_distinct(IP))
monthly_visits = as.data.frame(monthly_visits)
names(monthly_visits)[2] = "Total Visits"
names(monthly_visits)[3] = "Distinct Visits"

# Yearly visits
yearly_visits = csv_data %>% group_by(Year) %>% summarise(total_visits=n(), distinct_visits=n_distinct(IP))
yearly_visits = as.data.frame(yearly_visits)
names(yearly_visits)[2] = "Total Visits"
names(yearly_visits)[3] = "Distinct Visits"

# Daily page visits
daily_page_visits = csv_data %>% group_by(Date, Section) %>% summarise(total_visits=n(), distinct_visits=n_distinct(IP))
daily_page_visits = as.data.frame(daily_page_visits)
names(daily_page_visits)[3] = "Total Visits"
names(daily_page_visits)[4] = "Distinct Visits"

# Weekly page visits
weekly_page_visits = csv_data %>% group_by(Week=paste(Week, Year, sep="-"), Section) %>% summarise(total_visits=n(), distinct_visits=n_distinct(IP))
weekly_page_visits = as.data.frame(weekly_page_visits)
names(weekly_page_visits)[3] = "Total Visits"
names(weekly_page_visits)[4] = "Distinct Visits"

# Monthly page visits
monthly_page_visits = csv_data %>% group_by(Month=paste(Month, Year, sep="-"), Section) %>% summarise(total_visits=n(), distinct_visits=n_distinct(IP))
monthly_page_visits = as.data.frame(monthly_page_visits)
names(monthly_page_visits)[3] = "Total Visits"
names(monthly_page_visits)[4] = "Distinct Visits"

# Yearly page visits
yearly_page_visits = csv_data %>% group_by(Year, Section) %>% summarise(total_visits=n(), distinct_visits=n_distinct(IP))
yearly_page_visits = as.data.frame(yearly_page_visits)
names(yearly_page_visits)[3] = "Total Visits"
names(yearly_page_visits)[4] = "Distinct Visits"

# Article visits
article_visits = csv_data %>% filter(is.na(Author) == FALSE) %>% group_by(Page, Author) %>% summarise(total_visits=n(), distinct_visits=n_distinct(IP))
article_visits = as.data.frame(article_visits)
names(article_visits)[3] = "Total Visits"
names(article_visits)[4] = "Distinct Visits"

# Article visits time
article_visits_time = csv_data %>% filter(is.na(Author) == FALSE) %>% group_by(Month=paste(Month, Year, sep="-"), Page, Author) %>% summarise(total_visits=n(), distinct_visits=n_distinct(IP))
article_visits_time = as.data.frame(article_visits_time)
names(article_visits_time)[4] = "Total Visits"
names(article_visits_time)[5] = "Distinct Visits"

# Author visits
# 1. Article visits
author_article = csv_data %>% filter(is.na(Author) == FALSE) %>% group_by(ID=Author) %>% summarise(total_visits_2=n(), distinct_visits_2=n_distinct(IP))
author_article = as.data.frame(author_article)

# 2. Main page and blog page visits
blog_pages = csv_data %>% filter(Page %in% c("Nicholas", "Maria", "Rebeka", "Sherry", "Zara", "main_blog_page")) %>% group_by(ID=Page) %>% summarise(total_visits_1=n(), distinct_visits_1=n_distinct(IP))
blog_pages = as.data.frame(blog_pages)

# 3. Left outer join the two tables
author_visits = full_join(blog_pages, author_article, by = "ID")
author_visits$total_visits = rowSums(author_visits[,c(2,4)], na.rm = TRUE)
author_visits$distinct_visits = rowSums(author_visits[,c(3,5)], na.rm = TRUE)
author_visits = author_visits[,c(1,6,7)]
names(author_visits)[2] = "Total Visits"
names(author_visits)[3] = "Distinct Visits"
rm(author_article)
rm(blog_pages)

# Author visits time
# 1. Article visits time
author_article_time = csv_data %>% filter(is.na(Author) == FALSE) %>% group_by(Week=paste(Week, Year, sep="-"), ID=Author) %>% summarise(total_visits_2=n(), distinct_visits_2=n_distinct(IP))
author_article_time = as.data.frame(author_article_time)

# 2. Main page and blog page visits time
blog_pages_time = csv_data %>% filter(Page %in% c("Nicholas", "Maria", "Rebeka", "Sherry", "Zara", "main_blog_page")) %>% group_by(Week=paste(Week, Year, sep="-"), ID=Page) %>% summarise(total_visits_1=n(), distinct_visits_1=n_distinct(IP))
blog_pages_time = as.data.frame(blog_pages_time)

# 3. Left outer join the two tables
author_visits_time = full_join(blog_pages_time, author_article_time, by = c("Week", "ID"))
author_visits_time$total_visits = rowSums(author_visits_time[,c(3,5)], na.rm = TRUE)
author_visits_time$distinct_visits = rowSums(author_visits_time[,c(4,6)], na.rm = TRUE)
author_visits_time = author_visits_time[,c(1,2,7,8)]
names(author_visits_time)[3] = "Total Visits"
names(author_visits_time)[4] = "Distinct Visits"
rm(author_article_time)
rm(blog_pages_time)

# User Journey
csv_data$Session = paste(csv_data$IP, csv_data$Date, sep=" - ")
journey_data = as.data.frame(csv_data[,c(16,7,11)])
journey_data$Occurrence = 1:nrow(journey_data)

# Pages per visit
session_visit = journey_data %>% group_by(Session) %>% summarise(Pages=n())
session_visit = as.data.frame(session_visit)
pages_per_visit = session_visit %>% group_by(Pages) %>% summarise(Sessions=n())
pages_per_visit = as.data.frame(pages_per_visit)
pages_per_visit$Pages = as.character(pages_per_visit$Pages)
rm(session_visit)
rm(session_last_page)

# Drop-off section
session_last_page = journey_data %>% group_by(Session) %>% summarise(Last=max(Occurrence))
last_pages = session_last_page$Last
drop_pages = journey_data[journey_data$Occurrence %in% last_pages, 3]
drop_pages = as.data.frame(drop_pages)
drop_off_section = drop_pages %>% group_by(Page=drop_pages) %>% summarise(Drops=n())
drop_off_section = as.data.frame(drop_off_section)
rm(drop_pages)
rm(last_pages)
rm(journey_data)
