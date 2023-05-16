#!/bin/bash

# Created by Hari Chandan Pokuri 


# Lets now start the preprocess of the dataset based on few conditions given.

# Lets Load the dataset 
existing_file='/Users/harichandan/Desktop/UWA/UWA SEM3/Open Source tools and scripting/Assignment 2/Cyber_Security_Breaches_noym.tsv'
# find the missing values and store the updated data in new .tsv file
output_file="updated_data.tsv"

# Check missing values in each column and store the count in an array
sed 's/^\t/NA\t/g; s/\t\t/\tNA\t/g; s/\t$/\tNA/g' "$existing_file" > "$output_file"


# Add Month and Year columns based on Date_of_Breach column

date_updated_file="date_updated_file.tsv"

# Add Month and Year columns based on Date_of_Breach column
awk 'BEGIN{FS=OFS="\t"} {
    if ($4 ~ /^[0-9]{1,2}\/[0-9]{1,2}\/[0-9]{4}$/) {
        split($4, date_parts, "/")
        $8 = date_parts[1]  # Month column
        $9 = date_parts[3]  # Year column
    } else if ($4 ~ /^[0-9]{1,2}\/[0-9]{1,2}\/[0-9]{4}-[0-9]{1,2}\/[0-9]{1,2}\/[0-9]{4}$/) {
        split($4, date_range, "-")
        split(date_range[1], start_date_parts, "/")
        $8 = start_date_parts[1]  # Month column
        $9 = start_date_parts[3]  # Year column
    }
    print
}
NR==1 { $8 = "Month"; $9 = "Year" }  # Add column headers
' "$output_file" > "$date_updated_file"