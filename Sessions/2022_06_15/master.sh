# Create DNAm scores for CRP and IL-6 in ALSPAC

cd /exports/igmm/eddie/GenScotDepression/amelia/ALSPAC_inflam_episodes/DNAm

cp /exports/igmm/eddie/GenScotDepression/data/mdd_mwas_2021/probe_ch_cpgs/probes450k_to_remove_45759.txt Input/

qsub -N stagin -P sbms_CrossImmune Scripts/stagin.sh 

qsub -N DNAm -P sbms_CrossImmune Scripts/scores.sh 

qsub -N PCA_prep -P sbms_CrossImmune Scripts/PCA_dataframe.sh

# Submit array jobs to residualise CpGs:

for time in F7 cord
do

qsub -N "PCA_${time}_array" \
-hold_jid PCA_prep \
-P sbms_CrossImmune \
-t 25000-436416:25000 \
-v time=$time \
Scripts/PCA_res.sh 

qsub -N "PCA_${time}_finalarray" \
-hold_jid PCA_prep \
-P sbms_CrossImmune \
-v time=$time \
Scripts/PCA_res_final.sh 

# Calculate PCs
qsub -N "${time}_calc" \
-hold_jid PCA_* \
-P sbms_CrossImmune \
-v time=$time \
Scripts/PCA.sh

done


#### Comments to improve this script ####
# Instead of passing rowStart and rowEnd in the shell job script apply this logic in the R script instead.
# Make use of SGE_TASK_LAST and SGE_TASK_FIRST etc. 

