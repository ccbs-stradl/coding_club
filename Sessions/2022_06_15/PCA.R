# Calculate PCs
# DNAm regressed onto age, sex and array
# for DNAm of birth and age 7 separately
# --------------------------------------------------
library(dplyr)
library(tidyverse)
library(stringr)
library(tibble)
library(parallel)
library(optparse)
library(data.table)
library(gmodels)

setwd("/exports/igmm/eddie/GenScotDepression/amelia/ALSPAC_inflam_episodes/")
# --------------------------------------------------
# Read in time variable from environment
args = commandArgs(trailingOnly=TRUE)

parse <- OptionParser()

option_list <- list(
	make_option('--time', type = 'character', help = "'cord' or 'F7'", action = 'store')
)

opt <- parse_args(OptionParser(option_list=option_list), args = args)

time <- opt$time
# --------------------------------------------------
# Read in residuals and combine into one dataframe

files <- list.files("DNAm/Output/Residuals/")

# Split into cord or F7 time points

files <- files[str_detect(files, time)]
files

cl <- makeCluster(detectCores() - 1)
cl

csvs <- clusterApply(cl, files, function(file) {
	data.table::fread(paste0("DNAm/Output/Residuals/", file))
	})

stopCluster(cl)

res <- do.call(rbind, csvs)

# --------------------------------------------------
# Run PCA
pca <- fast.prcomp(res, scale = TRUE)

pcs <- pca$rotation[,1:50] %>%
		as.data.frame() %>%
		rownames_to_column("Subject")


# Remove X prefix of Subject
# ie. X1182_A to 1182_A in pcs$Subject

pcs <- pcs %>%
			mutate(Subject = str_remove(Subject, "X")) 

# Save PCs
if(time == "F7"){
	file <- "DNAm/Output/DNAm_PCs_age_7.csv"
}else{
	file <- "DNAm/Output/DNAm_PCs_age_0.csv"
}

write.csv(pcs, file, row.names = FALSE)


