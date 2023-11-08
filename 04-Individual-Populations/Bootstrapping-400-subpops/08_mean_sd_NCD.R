
library(tidyverse)

# Initialize an empty list to store data frames
data_list <- list()

# Loop through each set
for (i in 1:100) {
  # Loop through each population
  for (pop in 1:4) {
    # Construct the file path
    filepath <- paste0("set-", i, "/set-", i, "-pop", pop, "-ranked-by_dens.txt")
    
    # Read the file into a data frame
    temp_data <- read.table(filepath, header = TRUE)
    temp_data <- temp_data[, c("gene", "ncd05")]
    names(temp_data) <- c("gene", "ncd05")
    
    # Store the data frame in the list
    list_name <- paste0("set", i, "_pop", pop)
    data_list[[list_name]] <- temp_data
  }
}


# Initialize an empty data frame for the final result
final_data <- data_frame(gene = character(0))

# Loop through the list and merge
for (name in names(data_list)) {
  # Get the data frame
  temp_data <- data_list[[name]]
  
  # Rename the 'ncd05' column to make it unique across data frames
  temp_data <- rename(temp_data, !!paste0("ncd05_", name) := ncd05)
  
  # Merge with the final data frame
  final_data <- full_join(final_data, temp_data, by = "gene")
}


# Add a column with the mean ncd05 value for each gene
final_data <- final_data %>%
  rowwise() %>%
  mutate(
    mean_ncd05 = mean(c_across(starts_with("ncd05_")), na.rm = TRUE),
    sd_ncd05 = sd(c_across(starts_with("ncd05_")), na.rm = TRUE)
  ) %>%
  ungroup()


#Combine dfs to have information about all-240-samples from before.

bias_and_all <- read.table('input/2023_08_22_MASTER_cleaned_all_pops.txt',
                           header = TRUE)

bias_and_all <- merge(bias_and_all, final_data, by = "gene")
bias_and_all$candens <- as.factor(bias_and_all$candens)

#Write results and then load them into Rstudio for visualization
write.table(bias_and_all, "results/Master_ncd05_combined_400.txt",
            col.names = TRUE,
            quote = FALSE)