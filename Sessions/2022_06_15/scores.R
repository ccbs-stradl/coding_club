# Calculate DNA methylation scores in ALSPAC sample

library(dplyr)
library(tidyverse)
library(stringr)
library(data.table)
library(tibble)

setwd("/exports/igmm/eddie/GenScotDepression/amelia/ALSPAC_inflam_episodes/")
#setwd("/Users/aes/OneDrive - University of Edinburgh/PhD/Studies/ALSPAC_inflam_episodes")

load("DNAm/Input/betas/mvals.Robj")
mvals_na <- as.data.frame(mvals_na)
bkup <- mvals_na
load("DNAm/Input/betas/samplesheet_data.Rojb")
#load("/Volumes/cmvm/scs/groups/ALSPAC/data/genomics/B3421/methylation/B3421/samplesheet/data.Robj")

# Check what technical variables should be used as covariates
# See here for info: https://alspac.github.io/omics_documentation/alspac_omics_data_catalogue.html#org1b246a5

head(samplesheet)
length(unique(samplesheet$Slide))
length(unique(samplesheet$BCD_plate))

samplesheet %>%
filter(str_detect(time_code, "cord")) %>%
count(., sample_type)

samplesheet %>%
filter(str_detect(time_code, "F7")) %>%
count(., sample_type)

# -------------------------------------------------------
####### Subset samples

# Create subject variable
# QLET M = mother, A = first sib, B = second sib etc.
# cidB3421 = family ID
# Merge these two cols together to get unique individual ID
samplesheet <- samplesheet %>%
        		unite("Subject", c(cidB3421, QLET))

# Subset mvals for the time points we want using samplesheet references
samplesheet %>%
	filter(!str_detect(Subject, "M")) %>%
	pull(time_code) %>%
	unique()
# "TF1-3"     "antenatal" "FOM"       "F7"        "cord"      "F17"     "TF3"  

create_scores <- function(time){
# We want to get "Sample_Names" (in samplesheet) which
# - do not have "M" in QLET
# - contain the age we are lapplying over in time_code
samplesheet <- samplesheet %>%
	filter(!str_detect(Subject, "M")) %>%
	filter(str_detect(time_code, time)) 

nrow(samplesheet)
# 980

# then we want to subset mvals cols by these subseted Sample_Names
ncol(mvals_na) # 4854

mvals_na <- mvals_na %>%
	select(samplesheet$Sample_Name)

ncol(mvals_na) # 980 :-)

# additionally we want to rename these cols by the "Subject" col in samplesheet
# reorder samplesheet subject to same order as mvals_na cols
samplesheet <- samplesheet[match(colnames(mvals_na), samplesheet$Sample_Name),]
# test that worked:
sapply(1:ncol(mvals_na), function(i) colnames(mvals_na)[i] == samplesheet$Sample_Name[i]) %>% sum()

# rename cols
mvals_na %>%
	setnames(old = colnames(mvals_na), new = samplesheet$Subject)

# -------------------------------------------------------
####### Subset CpGs
# Subset the mvals dataframe into 
# - one dataframe with CRP CpGs
# - one dataframe with IL-6 CpGs

# Read in CpGs from publications (I manually copied them to txt files to read into R)
CRP <- read.csv("DNAm/Input/CpGs_CRP.csv", header = T, stringsAsFactors = F)
IL6 <- read.csv("DNAm/Input/CpGs_IL6.csv", header = T, stringsAsFactors = F)
IL6_Gadd <- read.csv("DNAm/Input/CpGs_IL6_Gadd.csv", header = T, stringsAsFactors = F)

# Subset and create new dataframes
mvalsCRP <- subset(mvals_na, rownames(mvals_na) %in% CRP$CpG) # contains all CpGs
mvalsIL6 <- subset(mvals_na, rownames(mvals_na) %in% IL6$CpG) # contains all CpGs
mvalsIL6_Gadd <- subset(mvals_na, rownames(mvals_na) %in% IL6_Gadd$CpG) # contains all CpGs

# -------------------------------------------------------
####### Calculate scores
# Use the effect_sizes to calculate scores for each individual
# Equation: 
# SUM(mval for CpGn * effect_size for CpGn)
# save results in new dataframe, each row is a subject, cols for scores

# Turn the below into a nice function which can take any list of CpGs and effect sizes and make scores.

##### CRP ######
# Merge effect sizes for CpGs into subsetted mvals dataframes
mvalsCRP <- rownames_to_column(mvalsCRP, "CpG")
mvalsCRP <- merge(mvalsCRP, CRP, by = "CpG")

# Check:
# mvalsCRP[,c(1,ncol(mvalsCRP))]
# CRP

scoresCRP <- mvalsCRP %>% 
				mutate_each( funs(.*Effect_size), !starts_with(c("CpG","Effect_size")) ) %>%
				select(!starts_with(c("CpG","Effect_size"))) %>%
				colSums() %>%
				data.frame("CRP_scores" = .) %>%
				rownames_to_column("Subject")


##### IL-6 ######
# Merge effect sizes for CpGs into subsetted mvals dataframes
mvalsIL6 <- rownames_to_column(mvalsIL6, "CpG")
mvalsIL6 <- merge(mvalsIL6, IL6, by = "CpG")

# Check:
# mvalsIL6[,c(1,ncol(mvalsIL6))]
#  IL6

scoresIL6 <- mvalsIL6 %>% 
				mutate_each( funs(.*Effect_size), !starts_with(c("CpG","Effect_size")) ) %>%
				select(!starts_with(c("CpG","Effect_size"))) %>%
				colSums() %>%
				data.frame("IL6_scores" = .) %>%
				rownames_to_column("Subject")

##### IL-6 (Updated CpGs from Danni Gadd)######
# Merge effect sizes for CpGs into subsetted mvals dataframes
mvalsIL6_Gadd <- rownames_to_column(mvalsIL6_Gadd, "CpG")
mvalsIL6_Gadd <- merge(mvalsIL6_Gadd, IL6, by = "CpG")

# Check:
# mvalsIL6[,c(1,ncol(mvalsIL6))]
#  IL6

scoresIL6_Gadd <- mvalsIL6_Gadd %>% 
				mutate_each( funs(.*Effect_size), !starts_with(c("CpG","Effect_size")) ) %>%
				select(!starts_with(c("CpG","Effect_size"))) %>%
				colSums() %>%
				data.frame("IL6_scores" = .) %>%
				rownames_to_column("Subject")

# -------------------------------------------------------
# Merge scores into one dataframe
scores <- merge(scoresCRP, scoresIL6, by = "Subject")
scores <- merge(scores, scoresIL6_Gadd, by = "Subject")
colnames(scores)[3:4] <- c("IL6_scores", "IL6_Gadd_scores")
nrow(scores) # 980 participants
return(scores)
}

scores_all_ages <- lapply(c("cord", "F7", "TF3", "F17"), create_scores)
names(scores_all_ages) <- c("birth", "7_years", "15_years", "17_years")

sapply(scores_all_ages, nrow)

# 7_years      15_years  17_years 
#      980      254      727 

# -------------------------------------------------------
# Merge scores for multiple ages
write.csv(scores_all_ages[[1]], "DNAm/Output/DNAm_scores_age_0.csv", row.names = F)
write.csv(scores_all_ages[[2]], "DNAm/Output/DNAm_scores_age_7.csv", row.names = F)
write.csv(scores_all_ages[[3]], "DNAm/Output/DNAm_scores_age_15.csv", row.names = F)
write.csv(scores_all_ages[[4]], "DNAm/Output/DNAm_scores_age_17.csv", row.names = F)




