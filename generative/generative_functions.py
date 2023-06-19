def new_videos_only(input_directory, output_directory, date):

    import os
    import pandas as pd

    # pull list of all filenames
    csv_files = [file_name for file_name in os.listdir(input_directory) if file_name.endswith(".csv")]

    # create list for data frames
    dataframes = []

    # laod in data frames
    for csv_file in csv_files:
        file_path = os.path.join(input_directory, csv_file)
        df = pd.read_csv(file_path)
        df["export_id"] = os.path.splitext(csv_file)[0]
        dataframes.append(df)

    # stack data
    stacked_files = pd.concat(dataframes, axis=0, ignore_index=True)

    # count callback metadata occurences 
    stacked_files["callback_metadata_count"] = stacked_files.groupby("callback_metadata")["callback_metadata"].transform("count")

    # define subset conditions
    callback_count_1   = stacked_files["callback_metadata_count"] == 1
    status_yes_neutral = stacked_files["status"].str.contains("yes")| stacked_files["status"].str.contains("neutral")

    # subset on conditions and by desired columns
    new_videos = stacked_files[callback_count_1 & status_yes_neutral][["callback_metadata", "export_id", "download_url"]]

    # export 
    new_videos.to_csv(output_directory + "videos_to_caption__" + date + ".csv", index=False)

    # print n new videos
    print("Generating CSV with ", len(new_videos), " new videos for captioning")