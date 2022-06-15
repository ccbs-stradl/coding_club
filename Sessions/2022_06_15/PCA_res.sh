#! /bin/sh
#$ -e /exports/igmm/eddie/GenScotDepression/amelia/ALSPAC_inflam_episodes/joblogs
#$ -o /exports/igmm/eddie/GenScotDepression/amelia/ALSPAC_inflam_episodes/joblogs
#$ -l h_vmem=64G
#$ -l h_rt=48:00:00
#$ -m beas
#$ -M amelia.edmondson-stait@ed.ac.uk

# Create DNAm PCs in ALSPAC

cd /exports/igmm/eddie/GenScotDepression/amelia/ALSPAC_inflam_episodes/DNAm

. /etc/profile.d/modules.sh
module load igmm/apps/R/3.6.1

# Get the number of CpGs, ie. the number of models we want to run
end=$(cat Output/PCs_CpGs.txt | wc -l)
end="$(($end-1))"

# Specify the range of CpGs we want to run the models on, 
# ie. rowStart is the index for the first CpG, and rowEnd is the index for the last CpG
# in our vector of CpGs loaded into R that R will lapply over.


echo "Running array job."
rowStart=$(($SGE_TASK_ID - 24999))
rowEnd=$SGE_TASK_ID


Rscript Scripts/PCA_res.R \
--time ${time} \
--rowStart ${rowStart} \
--rowEnd ${rowEnd}


