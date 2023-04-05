#!/bin/bash   
#$ -N stagein 
#$ -q staging

mkdir /exports/igmm/eddie/GenScotDepression/amelia/ALSPAC_inflam_episodes/DNAm/Input/betas

cp /exports/cmvm/datastore/scs/groups/ALSPAC/data/genomics/B3421/methylation/B3421/betas/* /exports/igmm/eddie/GenScotDepression/amelia/ALSPAC_inflam_episodes/DNAm/Input/betas

cp /exports/cmvm/datastore/scs/groups/ALSPAC/data/genomics/B3421/methylation/B3421/samplesheet/data.Robj /exports/igmm/eddie/GenScotDepression/amelia/ALSPAC_inflam_episodes/DNAm/Input/betas/samplesheet_data.Rojb


