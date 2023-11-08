
library(dplyr)
library(tidyr)

# Loop through each set directory
for (j in 1:100) {
  # Define the directory
  set_dir <- paste0("set-", j)
  
  # Define the file names
  file_names <- paste0(set_dir, "/", set_dir, "-pop", 1:4, "-ranked-by_dens.txt")
  
  # Initialize an empty list to store data frames
  list_of_tables <- list()
  
  # Loop through each file to read it
  for (i in 1:4) {
    # Read the table
    current_table <- read.table(file_names[i], header = TRUE, stringsAsFactors = FALSE)
    
    # Remove unnecessary columns
    current_table <- current_table %>% select(-c("chr", "snp", "start", "end", "ncd04", "ncd03", "facet", "candens"))
    
    # Get the names of columns to be changed (excluding 'gene')
    colnames_to_change <- setdiff(colnames(current_table), "gene")
    
    # Create a named vector for renaming columns
    new_colnames <- c("gene", paste0(colnames_to_change, "_pop", i))
    
    # Rename columns
    names(current_table) <- new_colnames
    
    # Add it to the list
    list_of_tables[[i]] <- current_table
  }
  
  # Merge all tables by 'gene' column
  merged_table <- Reduce(function(x, y) merge(x, y, by = "gene"), list_of_tables)
  
  # Sanitize set_dir for use in column names
  set_name_sanitized <- gsub("-", "_", set_dir)
  
  # Calculate mean and standard deviation for 'clr', 'ncd05', and 'density'
  merged_table <- merged_table %>%
    rowwise() %>%
    mutate(
      !!paste0("mean_clr_", set_name_sanitized) := mean(c_across(starts_with("clr")), na.rm = TRUE),
      !!paste0("sd_clr_", set_name_sanitized) := sd(c_across(starts_with("clr")), na.rm = TRUE),
      !!paste0("mean_ncd05_", set_name_sanitized) := mean(c_across(starts_with("ncd05")), na.rm = TRUE),
      !!paste0("sd_ncd05_", set_name_sanitized) := sd(c_across(starts_with("ncd05")), na.rm = TRUE),
      !!paste0("mean_density_", set_name_sanitized) := mean(c_across(starts_with("density")), na.rm = TRUE),
      !!paste0("sd_density_", set_name_sanitized) := sd(c_across(starts_with("density")), na.rm = TRUE)
    )
  
  # Eliminate some columns
  merged_table <- merged_table %>% select(-starts_with("clr_pop"), -starts_with("ncd05_pop"), -starts_with("density_pop"))
  
  # Save this merged table to a new file within the same set directory
  write.table(merged_table, file = file.path(set_dir, paste0("final_table_", set_dir, ".txt")), 
              sep = "\t", row.names = FALSE, quote = FALSE)
}

#############

# Initialize an empty list to store the 100 final tables
list_of_final_tables <- list()

# Loop through each set directory to read the final table
for (j in 1:100) {
  # Define the directory
  set_dir <- paste0("set-", j)
  
  # Define the final table file name
  final_file_name <- paste0(set_dir, "/final_table_", set_dir, ".txt")
  
  # Read the final table
  final_table <- read.table(final_file_name, header = TRUE, stringsAsFactors = FALSE)
  
  # Add it to the list
  list_of_final_tables[[j]] <- final_table
}

# Merge all 100 final tables by 'gene' column
final_merged_table <- Reduce(function(x, y) merge(x, y, by = "gene", all = TRUE), list_of_final_tables)

# Identify the columns for each type of value
clr_columns <- grep("clr", colnames(final_merged_table), value = TRUE)
ncd05_columns <- grep("ncd05", colnames(final_merged_table), value = TRUE)
density_columns <- grep("density", colnames(final_merged_table), value = TRUE)

# Create tables for each type of value
final_clr_table <- final_merged_table %>% select(c("gene", clr_columns))
final_ncd05_table <- final_merged_table %>% select(c("gene", ncd05_columns))
final_density_table <- final_merged_table %>% select(c("gene", density_columns))

# Save these tables to new files
write.table(final_clr_table, file = "results/final_clr_table_by_sets.txt", sep = "\t", 
            row.names = FALSE, quote = FALSE)
write.table(final_ncd05_table, file = "results/final_ncd05_by_sets.txt", sep = "\t", 
            row.names = FALSE, quote = FALSE)
write.table(final_density_table, file = "results/final_density_by_sets.txt", sep = "\t", 
            row.names = FALSE, quote = FALSE)

