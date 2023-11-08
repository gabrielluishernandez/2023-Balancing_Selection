
#install.packages("tidyverse")
#install.packages("MASS")
library(tidyverse)
library(MASS)

# Define the list of populations
populations <- c("pop1", "pop2", "pop3", "pop4")

# Loop through each population
for (pop in populations) {
  # Your code here
  # You can use the 'pop' variable to replace ${i}
  filepath <- paste0('set-17/set-17-', pop, '-Final_Genes_Scored.txt')

bias_and_all <- read.table(filepath,
                           header = FALSE,
                           quote = "",
                           col.names = c("gene","chr","snp","clr","start","end",
                                         "ncd05","ncd04","ncd03"))


# Organized by clr
bias_and_all <- bias_and_all[order(bias_and_all$clr,
                                   decreasing = TRUE), ]

#eliminate duplicates keeping the entry with the highest clr per gene.

bias_and_all <- bias_and_all[!duplicated(bias_and_all$gene), ]


bias_and_all$facet = factor(bias_and_all$chr,
                         levels = c("CM031901.1", "CM031902.1", "CM031903.1",
                                    "CM031904.1", "CM031905.1", "CM031906.1",
                                    "CM031907.1", "CM031908.1", "CM031909.1",
                                    "CM031910.1", "CM031911.1", "CM031912.1",
                                    "CM031913.1", "CM031914.1", "CM031915.1"
                                    ))



# Density-base selection

theme_set(theme_bw(base_size = 16))

get_density <- function(x, y, ...) {
  dens <- MASS::kde2d(x, y, ...)
  ix <- findInterval(x, dens$x)
  iy <- findInterval(y, dens$y)
  ii <- cbind(ix, iy)
  return(dens$z[ii])
}

set.seed(1)


sd_clr <- sd(bias_and_all$clr)
sd_ncd <- sd(bias_and_all$ncd05)


bias_and_all$density <- get_density(bias_and_all$clr/sd_clr,
                                    bias_and_all$ncd05/sd_ncd,
                                    h = c(10, 10), n = 500)


## Candidate genes
# Select the top 1%

quantile(bias_and_all$density, 0.01)

bias_and_all$candens <- "0"

for(i in 1:nrow(bias_and_all)) {
  if(is.na(bias_and_all$clr[i])){
    next
  }
  if(bias_and_all$density[i] <= quantile(bias_and_all$density, 0.01)){
    bias_and_all$candens[i]  <- "1"
  }
}

bias_and_all$candens <- as.factor(bias_and_all$candens)

#Organize by clr
bias_and_all <- bias_and_all[order(bias_and_all$density, decreasing = FALSE), ]

#eliminate duplicates keeping the entry with the highest clr per gene.
bias_and_all <- bias_and_all[!duplicated(bias_and_all$gene), ]

nrow(subset(bias_and_all, candens == "1"))



#Write the output

bias_and_all <- arrange(bias_and_all, density)

write.table(bias_and_all,
            paste0("set-17/set-17-", pop, "-ranked-by_dens.txt"),
            quote = FALSE,
            col.names = TRUE,
            row.names = FALSE)

write.table(bias_and_all$gene,
            paste0("set-17/set-17-", pop, "-All-Genes.txt"),
            quote = FALSE,
            col.names = FALSE,
            row.names = FALSE)

candidates <- subset(bias_and_all, candens == "1")

write.table(candidates$gene,
            paste0("set-17/set-17-", pop, "-Candidate_Genes_only.txt"),
            quote = FALSE,
            col.names = FALSE,
            row.names = FALSE)

}
