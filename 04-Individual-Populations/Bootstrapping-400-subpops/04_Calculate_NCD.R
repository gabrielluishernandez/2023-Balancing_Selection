# Source required functions
source('NCD-statistics/scripts/preamble.R')
source('NCD-statistics/scripts/NCD_func.R')

# Loop over each directory (set-1 to set-100)
for (set_i in 1:100) {
  # Loop over each file within the directory (pop1_input_NCD.rds to pop4_input_NCD.rds)
  for (pop_i in 1:4) {
    
    input_file_path <- paste0("set-", set_i, "/pop", pop_i, "_input_NCD.rds")
    output_file_path <- paste0("set-", set_i, "/pop", pop_i, "-NCD1_win5Kb_step2500b.txt")
    
    # Load input
    readRDS(input_file_path) -> SNP_input
    
    # Initialize an empty data frame to hold results
    sep.run.ncd1 <- data.frame()
    
    # Perform computation
    for (x in 1:15) {
      result_chunk <- NCD1(X = SNP_input[[x]], W = 5000, S = 2500)
      sep.run.ncd1 <- rbind(sep.run.ncd1, result_chunk)
    }
    
    # Write output to file
    write.table(sep.run.ncd1, file = output_file_path, quote = FALSE, row.names = FALSE, sep = "\t")
  }
}

