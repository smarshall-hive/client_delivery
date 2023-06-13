## -------------------------------------------------------------------------- ##
## title: 
## description: 
## author: 
## date: 
## -------------------------------------------------------------------------- ##

## p0: load packages and set parms ---------------------------------------------

  # load packages 
  library(data.table)
  
  # source all reddit functions
  source("/Users/smarshall/Desktop/projects/reddit/reddit_code/reddit_functions.R")

  # set directory
  p_directory <- "/Users/smarshall/Desktop/projects/reddit/"
  
  # set filename
  p_filename <- "pilot_2_data"

## p1: load data ---------------------------------------------------------------

  # load raw reddit data
  raw_reddit <- fread(paste0(p_directory, "/raw_data/", p_filename, ".csv"))
  
  # load immediate hive export
  
  
## p2: run pre processing --------------------------------------------------

  # run pre processing to upload 
  v_text_preprocessing(raw_reddit)
  
  # create text map 
  v_text_create_map(raw_reddit, hive_export)