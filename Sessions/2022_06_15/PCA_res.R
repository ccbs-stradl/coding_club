# Calculate PCs
# DNAm regressed onto age, sex and array
# for DNAm of birth and age 7 separately
# --------------------------------------------------
library(dplyr)
library(tidyverse)
library(stringr)
library(tibble)
library(optparse)
library(pbapply)

setwd("/exports/igmm/eddie/GenScotDepression/amelia/ALSPAC_inflam_episodes/")
# --------------------------------------------------
# Read in time variable from environment
args = commandArgs(trailingOnly=TRUE)

parse <- OptionParser()

option_list <- list(
	make_option('--time', type = 'character', help = "'cord' or 'F7'", action = 'store'),
	make_option('--rowStart', type = 'integer', help = "integer of CpG index to start from", action = 'store'),
	make_option('--rowEnd', type = 'integer', help = "integer of CpG index to end with", action = 'store')
)

opt <- parse_args(OptionParser(option_list=option_list), args = args)

time <- opt$time
rowStart <- opt$rowStart
rowEnd <- opt$rowEnd
#-----------------------------------------------
# Read in data
data <- readRDS(paste0("DNAm/Output/PCs_data_", time,".rds"))
cpgs <- read.table(paste0("DNAm/Output/PCs_CpGs.txt"), sep = "\t") %>% pull(1) %>% as.character()

#-----------------------------------------------
# Limit CpGs to numbers parsed from linux environment
cpgs <- cpgs[rowStart:rowEnd]

#-----------------------------------------------
# Calculate residuals
residuals <- pblapply(cpgs, function(CpG){

# Select correct covariates for different time points, 
# ie. dont need age as a covariate for DNAm collected at birth
		if(time == "F7"){
			form <- paste0(CpG, " ~ age + Sex + Slide")
		}else{
			form <- paste0(CpG, " ~ Sex + Slide")
		}

	# Fit the model 
	fit <- lm(formula = form, data = data)
	res <- residuals(fit)
	return(res)
	})

res <- do.call(rbind, residuals)
colnames(res) <- data$Subject
head(res) 


file <- paste0("DNAm/Output/Residuals/residuals_",time, "_", rowStart, "_", rowEnd, ".csv")
write.csv(res, file, row.names = F, quote = F)



# --------------------------------------------------
