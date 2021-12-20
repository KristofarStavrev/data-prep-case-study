# Load libraries ----
library(stringr)
library(lubridate)
library(R.utils)
library(dplyr)

# Declare variable constants ----
rm(list=ls())
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
folders_path = ".\\logs"
db_folder = ".\\db"
db_file = ".\\db\\db_raw_data.csv"
min_byte_size = 3000
resp_code = 200
access_method = "GET"
filter_strings_1 = "debug|static"
filter_strings_2 = "bot|crawler|agent|research|scan|data|grab|http|python|curl|grequests|embarcadero|\\.com"
path_exclusions = "\\.php|\\?"

# Get all data folders and logs ----
data_folders = list.dirs(folders_path, full.names = FALSE)

if (length(data_folders) < 2) {
  # Clear environment
  rm(list=ls())
  cat("\014")
  message("No data found, check logs folder")
} else {
  data_folders = data_folders[-1]
  
  # Check if database directory exists and create it if it doesn't
  if (dir.exists(db_folder) == FALSE) {
    dir.create(db_folder)
  }

  # Loop through folders and files 
  for (directory in data_folders) {
    logs = list.files(file.path(folders_path, directory, fsep="\\"))
    
    # Find archived files and extract them
    for(i in logs) {
      if (str_detect(i, ".gz")) {
        gunzip(file.path(folders_path, directory, i), remove=FALSE)
      }
    }
    
    # Find all files that are to be imported
    logs = list.files(file.path(folders_path, directory, fsep="\\"))
    for (el in logs) {
      if (str_detect(el, ".gz") == FALSE & el != "access.log") {
        
  
        # Import data ----
        raw_data = read.table(file.path(folders_path, directory, el, fsep="\\"), header=FALSE, sep=' ')
        
        # Process raw data ----
        # Remove unnecessary columns and name the rest
        raw_data = raw_data[,c(-2,-3,-5,-9)]
        names(raw_data)[1] = "IP"
        names(raw_data)[2] = "Date"
        names(raw_data)[3] = "Page_Access_Method_and_Path"
        names(raw_data)[4] = "Response_Code"
        names(raw_data)[5] = "Bytes"
        names(raw_data)[6] = "User_Agent"
        
        # Create auxiliary table to check column type and NAs
        aux=data.frame(cls=sapply(raw_data, class), nas=colSums(is.na(raw_data)))
        
        # Fix date format
        raw_data$Date = dmy_hms(sapply(raw_data$Date, function (x){gsub("[", "", x, fixed=TRUE)}))
        raw_data$Time = format(as.POSIXct(raw_data$Date),format = "%H:%M:%S")
        raw_data$Date = as.Date(raw_data$Date)
        raw_data$Year = year(raw_data$Date)
        raw_data$Month = month(raw_data$Date)
        raw_data$Day = day(raw_data$Date)
        
        aux=data.frame(cls=sapply(raw_data, class), nas=colSums(is.na(raw_data)))
        
        # Exclude rows that contain useless for the analysis information
        raw_data$Page_Access_Method_and_Path = sapply(raw_data$Page_Access_Method_and_Path, function (x){trimws(x, which=c("left"))})
        
        raw_data = raw_data[raw_data$Bytes>=min_byte_size & raw_data$Response_Code==resp_code & substr(raw_data$Page_Access_Method_and_Path,1,3)==access_method & str_detect(raw_data$Page_Access_Method_and_Path, paste("(?i)",filter_strings_1,sep=""))==FALSE & str_detect(raw_data$User_Agent, paste("(?i)", filter_strings_2, sep=""))==FALSE,]
        
        # Extract information about the accessed page
        raw_data$Path = sapply(raw_data$Page_Access_Method_and_Path, function (x){strsplit(x, " ")[[1]][[2]]})
        raw_data$Page = sapply(raw_data$Path, function (x){strsplit(x, "/")[[1]][[length(strsplit(x, "/")[[1]])]]})
        raw_data$Path[which(raw_data$Path == "/")] = "/MainPage/"
        raw_data$Page[which(raw_data$Page == "")] = "Main Page"
        raw_data = raw_data[,c(1,8,9,10,2,7,3,11,12,4,5,6)]
        
        raw_data = raw_data[str_detect(raw_data$Page, paste("(?i)",path_exclusions,sep=""))==FALSE,]
        
        # Save processed data in a csv database ----
        # Check if database file already exists
        if (file.exists(db_file)) {
          
          # If it exists then append the new data to it
          write.table( raw_data,  
                       file=db_file, 
                       append = T, 
                       sep=',', 
                       row.names=F, 
                       col.names=F )
          
        } else {
          
          # If it does not then create a new one
          write.csv(raw_data, db_file, row.names = FALSE)
          
        }
      }
    }
  
  # Delete imported folder and files ----
  unlink(file.path(folders_path, directory), recursive = TRUE, force = TRUE)
      
  }
  
  # Remove duplicate rows form the database and order data ----
  clean_data = read.csv(db_file, stringsAsFactors = F)
  clean_data = clean_data %>% distinct()
  clean_data = arrange(clean_data, Date, Time, IP)
  
  write.csv(clean_data, db_file, row.names = FALSE)
  
  # Clear environment
  rm(list=ls())
  
  cat("\014")
  message("Import completed successfully!")
}