## -------------------------------------------------------------------------- ##
## title: V Text Processing Functions
## description: Home base for all Reddit V Text functions 
## author: s.marshall 
## date: 
## -------------------------------------------------------------------------- ##

## p1: write pre processing function -------------------------------------------
  
  v_text_preprocessing <- function(raw_data) {
    
    # copy for formatting
    reddit <- copy(raw_data)
    
    # attach unique_id
    reddit[, id := seq(nrow(raw_reddit))]
    
    # find count of texts -- looking for dupes or greater
    reddit[, text_count := .N, by = text]
    
      # print number of dupes
      print(paste0(nrow(reddit[text_count > 1]), " duplicated text strings"))
    
    # attach by row unique id using composite key -- guards against removal of rows 
    reddit[, composite_key := paste0(id, "__", sample_id)]
    
    # count text length
    reddit[, char_count := nchar(text)]
  
      # print n text over char limit
      print(paste0(nrow(reddit[char_count > 1024]), " text strings over Hive's character limit of 1024"))

    # subset to unique text strings
    unique_reddit <- subset(reddit, text_count == 1)
    
    # print write notif 
    print(paste0("Writing CSV with ", nrow(unique_reddit), " rows"))
    
    # write to csv
    write.csv(unique_reddit, 
              paste0(p_directory, "processed_data/", p_filename, "_processed.csv"), 
              row.names = FALSE)
    
    print("Complete")
    
  }
  

## p2: write map table function ------------------------------------------------

  v_text_create_map <- function(raw_data, hive_export) {
    
    # merge tables
    merged <- merge(raw_data, 
                    hive_export, 
                    by.x = "text", 
                    by.y = "text_data", 
                    all = TRUE)
    
    print("Writing mapping csv")
    
    # write mapping csv
    write.csv(subset(merged, select = c("task_id", "sample_id", "callback_metadata", "text_data")), 
              paste0(p_directory, "processed_data/", p_filename, "_map.csv"), 
              row.names = FALSE)
    
    print("Complete")
    
  }