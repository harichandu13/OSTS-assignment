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
    if ($4 ~ /^[0-9]{1,2}\/[0-9]{1,2}\/[0-9]{2}$/ || $4 ~ /^[0-9]{1,2}\/[0-9]{1,2}\/[0-9]{4}$/) {
        split($4, date_parts, "/")
        month = sprintf("%02d", date_parts[1])  # Month column with leading zero
        year = sprintf("%04d", date_parts[3])  # Year column with four digits
        if (length(date_parts[3]) == 2) {  # Handle two-digit year format
            year = "20" date_parts[3]
        }
        $8 = month  # Month column
        $9 = year  # Year column
    } else if ($4 ~ /^[0-9]{1,2}\/[0-9]{1,2}\/[0-9]{2}-[0-9]{1,2}\/[0-9]{1,2}\/[0-9]{2}$/ || $4 ~ /^[0-9]{1,2}\/[0-9]{1,2}\/[0-9]{2}-[0-9]{1,2}\/[0-9]{1,2}\/[0-9]{4}$/) {
        split($4, date_range, "-")
        split(date_range[1], start_date_parts, "/")
        month = sprintf("%02d", start_date_parts[1])  # Month column with leading zero
        year = sprintf("%04d", start_date_parts[3])  # Year column with four digits
        if (length(start_date_parts[3]) == 2) {  # Handle two-digit year format
            year = "20" start_date_parts[3]
        }
        $8 = month  # Month column
        $9 = year  # Year column
    }
    print
}
NR==1 { $8 = "Month"; $9 = "Year" }  # Change column headers
' "$output_file" > "$date_updated_file"


fileafter_breach='fileafter_breach.tsv'
# Remove everything in Type_of_Breach column after the first comma or slash
awk 'BEGIN{FS=OFS="\t"} {
    if ($5 ~ /[,\/]/) {
        split($5, type_parts, /[,\/]/)
        $5 = type_parts[1]
    }
    print
}' "$date_updated_file" > "$fileafter_breach"


# Drop columns  (Location_of_Breached_Information and Summary)
column_names=("Location_of_Breached_Information" "Summary")
column_drop_table='column_drop_table.tsv'
cut -f 1-5,8- "$fileafter_breach" > "$column_drop_table"
# This Drops the specified columns

