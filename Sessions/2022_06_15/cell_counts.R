# Process cell counts data frame to get subject IDs that match our main dataset

library(dplyr)
library(tidyverse)
library(stringr)
library(data.table)
library(tibble)

setwd("/Users/aes/OneDrive - University of Edinburgh/PhD/Studies/ALSPAC_inflam_episodes")

# Read in cell count data
cell_counts <- read.table("/Volumes/ALSPAC/data/genomics/B3421/methylation/B3421/derived/cellcounts/houseman/data.txt", header = T)
head(cell_counts)

# load samplesheet to get Subject Ids
load("/Volumes/ALSPAC/data/genomics/B3421/methylation/B3421/samplesheet/data.Robj")

head(samplesheet)
samplesheet <- samplesheet %>%
  unite("Subject", c(cidB3421, QLET))

nrow(cell_counts)
nrow(samplesheet)

# Add Subject col to cell_counts
data <- merge( dplyr::select(samplesheet, c("Sample_Name", "Subject", "time_code", "time_point", "duplicate.rm")), cell_counts, by = "Sample_Name" )

# Save to output
write.csv(data, "DNAm/Output/cell_counts.csv", row.names = F)
