#! /bin/sh
#$ -e /exports/igmm/eddie/GenScotDepression/amelia/ALSPAC_inflam_episodes/joblogs
#$ -o /exports/igmm/eddie/GenScotDepression/amelia/ALSPAC_inflam_episodes/joblogs
#$ -l h_vmem=64G
#$ -l h_rt=48:00:00
#$ -m beas
#$ -M amelia.edmondson-stait@ed.ac.uk

# Create DNAm scores for CRP and IL-6 in ALSPAC

cd /exports/igmm/eddie/GenScotDepression/amelia/ALSPAC_inflam_episodes/DNAm

. /etc/profile.d/modules.sh
module load igmm/apps/R/3.6.1

Rscript Scripts/scores.R

Rscript Scripts/cell_counts.R

