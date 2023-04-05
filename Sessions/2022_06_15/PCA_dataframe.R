# Calculate PCs
# First save the dataframes needed
# DNAm regressed onto age, sex and array
# for DNAm of birth and age 7 separately
# --------------------------------------------------
library(dplyr)
library(tidyverse)
library(stringr)
library(tibble)

# --------------------------------------------------
setwd("/exports/igmm/eddie/GenScotDepression/amelia/ALSPAC_inflam_episodes/")
load("DNAm/Input/betas/mvals.Robj")
mvals_na <- as.data.frame(mvals_na)

# --------------------------------------------------
# Remove cross-reactive and polymorphic CpGs 
cpg_rm <- read.table("DNAm/Input/probes450k_to_remove_45759.txt", header = TRUE, sep = "\t")
sum(rownames(mvals_na) %in% cpg_rm$cpg) # 44171

mvals <- mvals_na[-which(rownames(mvals_na) %in% cpg_rm$cpg),]
nrow(mvals) # 438684
nrow(mvals_na) # 482855

mvals[1:5,1:5] # rows are CpGs, cols are Slides/participants

rm(mvals_na)
# --------------------------------------------------
# Load sample sheet
load("DNAm/Input/betas/samplesheet_data.Rojb")
head(samplesheet)

# --------------------------------------------------
# Make into a function/lapply to birth or age 7 samples,
# depending on time variable read in from terminal

cpgs <- lapply(c("F7", "cord"), function(time){
# Subset samplesheet to correct time point
covariates <- samplesheet %>%
	unite(Subject, c("cidB3421", "QLET")) %>%
	filter(time_point %in% time) %>%
	mutate(Slide = as.factor(Slide)) %>%
	mutate(Sex = as.factor(Sex)) %>%
	mutate(age = as.numeric(age)) %>%
	select(c(Sample_Name, Subject, Slide, Sex, age))
	
# Subset mvals to Slides in covariates file, ie at correct time point
mvalsSub <- mvals %>%
				drop_na() %>%
				select(covariates$Sample_Name) %>%
				t() %>%
				as.data.frame() %>%
				rownames_to_column("Sample_Name")

# Check same number of participants in both
nrow(mvalsSub) == nrow(covariates)

# Merge into one dataframe
data <- merge(mvalsSub, covariates, by = "Sample_Name")

saveRDS(data, paste0("DNAm/Output/PCs_data_", time,".rds"))

cpgs <- colnames(data)[!colnames(data) %in% c("Sample_Name", "Subject", "Sex", "age", "Slide")]

# return(paste0("Output saved for time point: ", time))
return(cpgs)
})

lapply(cpgs, length)
write.table(cpgs[[1]], "DNAm/Output/PCs_CpGs.txt", sep = "\t")

system("mkdir DNAm/Output/Residuals")



