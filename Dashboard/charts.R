# Load libraries ----
library(lubridate)
library(dplyr)
library(googleVis)
library(shiny)
# Import data ----
rm(list=ls())
setwd(paste(dirname(rstudioapi::getSourceEditorContext()$path),"/db",sep=""))

csv_data=read.csv("db_raw_data.csv", stringsAsFactors = F, na.strings = c("NA", "", " "))

# Check the class of each vector from the data frame
aux_table = data.frame(nm=names(csv_data), cl=sapply(csv_data, class), nas=colSums(is.na(csv_data)))

csv_data$Date = ymd(csv_data$Date)

# Aggregate data ----
visit_month = dd %>% group_by(Year, Month) %>% summarise(n_orders=n(),sum_sales=sum(Sales)) #%>% arrange(desc(sum_sales))
dda= as.data.frame(dda)

tesing
