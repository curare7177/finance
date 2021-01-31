#### -- Packrat Autoloader (version 0.5.0) -- ####
source("packrat/init.R")
#### -- End Packrat Autoloader -- ####

#### -- .First and .Last -- ####
.First = function(){
  cat('Welcome R at', date(), '\n')

  # Environment setting check ----
  if(Sys.getenv('ENV') == '' | is.null(Sys.getenv('ENV'))){
    Sys.setenv('ENV' = 'prod')
  }
  if(Sys.getenv('SECRET_FILE') == '' | is.null(Sys.getenv('SECRET_FILE'))){
    Sys.setenv('SECRET_FILE' = 'configs/config_secret.yml')
  }
  # End Environment setting check

  # System File Prepairing ----
  if(!file.exists(paste0(system.file('java', package = 'mailR'), '/javax.activation-1.2.0.jar')) |
     !file.exists(paste0(system.file('java', package = 'mailR'), '/javax.activation-api-1.2.0.jar'))){
    system(paste0('cp sys/javax.activation-1.2.0.jar sys/javax.activation-api-1.2.0.jar ', system.file('java', package = 'mailR')))
  }
  # End System File Prepairing

  # Option Setting ----
  options('scipen' = 999) # options(scipen = 0)
  # End Option Setting

  # Install and load R packages ----
  library('packrat')
  packrat::on()

  # source('sys/ipak.R')
  packages <- c('packrat',
                # Log tools ----
                'futile.logger', # A Logging Utility for R
                # Utilities ----
                'R.utils', # Various Programming Utilities
                'doParallel', # Foreach Parallel Adaptor for the 'parallel' Package
                'mailR', # A Utility to Send Emails from R
                # Config tools and access data tools ----
                'yaml', # Methods to Convert R Data to YAML and Back
                'jsonlite', # A Robust, High Performance JSON Parser and Generator for R
                ## Install this package by using install_github('cloudyr/aws.s3', ref = 'v0.3.12') ----
                'aws.s3', # A simple client package for the Amazon Web Services (AWS) Simple Storage Service (S3) REST API.
                'RMySQL', # Database Interface and 'MySQL' Driver for R
                # 'elastic', # General Purpose Interface to 'Elasticsearch'
                'mongolite', # Fast and Simple 'MongoDB' Client for R
                # Communicate with other language ----
                'reticulate', # R Interface to Python
                'arrow', # Integration to 'Apache' 'Arrow'
                # Manipulate Data ----
                'tidyverse', # Easily Install and Load the 'Tidyverse'
                'lubridate' , # Make Dealing with Dates a Little Easier
                # Statistical Tools ----
                'recommenderlab', # Lab for Developing and Testing Recommender Algorithms
                # Graphics:	Graphic Displays & Dynamic Graphics & Graphic Devices & Visualization ----
                # 'ggplot2', # An Implementation of the Grammar of Graphics
                # Applications ----
                # 'shiny', # Web Application Framework for R
                'WriteXLS') # Cross-Platform Perl Based R Function to Create Excel 2003 (XLS) and Excel 2007 (XLSX) Files
  invisible(suppressWarnings(suppressPackageStartupMessages(sapply(packages, require, character.only = TRUE, warn.conflicts = FALSE, quietly = TRUE))))

  # Config file setting ----
  config <- yaml.load_file(paste0('configs/config_', Sys.getenv('ENV'), '.yml'))
  config_secret <- yaml.load_file(Sys.getenv('SECRET_FILE'))
  config$general$job_status_file <- ifelse(!is.null(config_secret$general$job_status_file), config_secret$general$job_status_file, config$general$job_status_file)
  config$general$log_file <- ifelse(!is.null(config_secret$general$log_file), config_secret$general$log_file, config$general$log_file)
  # End Config file setting

  # Job status file Processing ----
  if(!file.exists(config$general$job_status_file)){
    create_job_status_file <- file.create(config$general$job_status_file)
    cat('Creating job status file:', create_job_status_file, '\n')
  }
  # End Job status file Processing

  # Log file Processing ----
  if(!file.exists(config$general$log_file)){
    create_log_file <- file.create(config$general$log_file)
    cat('Creating log file:', create_log_file, '\n')
  }
  # End Log file Processing
}

.Last = function(){
  # Job status file Processing ----
  if(file.exists(JOB_STATUS_FILE)){
    if(Sys.getenv('ENV') == 'local'){
      Sys.sleep(.02) # The time interval to suspend execution for, in seconds. The resolution of the time interval is system-dependent, but will normally be 20ms or better. (On modern Unix-alikes it will be better than 1ms.)
    }else{
      Sys.sleep(15)
    }
    delete_job_status_file <- file.remove(JOB_STATUS_FILE)
    cat('Delete job status file:', delete_job_status_file, '\n')
  }
  # End Job status file Processing

  # Log file Processing ----
  if(file.exists(LOG_FILE)){
    clean_log_file <- close(file(LOG_FILE, open = 'w')) # system(paste('true >', LOG_FILE))
    cat('Clean log file:', ifelse(clean_log_file == 0, TRUE, FALSE), '\n')
  }
  # End Log file Processing

  cat('Goodbye at ', date(), '\n')
}
#### -- End .First and .Last -- ####
