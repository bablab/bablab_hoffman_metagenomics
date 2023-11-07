#### run_kneaddata_forloop.sh START ###
#!/bin/bash
#$ -cwd
# error = Merged with joblog
#$ -o /u/home/f/fquerdas/bablab/data/mbb/microbiome/joblogs/joblog.$JOB_ID
#$ -j y
# Edit the line below as needed
#$ -l h_rt=24:00:00,h_data=4G
# Add multiple cores/nodes as needed:
#$ -pe shared 20
# Email address to notify
#$ -M $USER@mail
# Notify when
#$ -m bea

# echo job info on joblog:
echo "Job $JOB_ID started on:   " `hostname -s`
echo "Job $JOB_ID started on:   " `date `
echo " "

# load the job environment:
. /u/local/Modules/default/init/modules.sh
module load python/3.9.6
export BIOBAKERY_WORKFLOWS_DATABASES=/u/local/apps/BIOBAKERY/biobakery_workflows_databases
source /u/local/apps/PYTHON-VIRT-ENVS/3.9.6/biobakery/bin/activate
export PATH=/u/local/apps/TRF/4.09.1/bin:$PATH
module load samtools
module load fastqc
echo " "

# Change the 4 lines below with the actual instructions you need:
kneaddata --input $1 --input $2 --output-prefix ${1%%_*}_kneaddata --output /u/home/f/fquerdas/bablab/data/mbb/microbiome/w1_kneaddata --reference-db /u/local/apps/BIOBAKERY/biobakery_workflows_databases/kneaddata_db_human_genome --serial --run-trf --threads 20 --processes 20 --remove-intermediate-output --cat-final-output --run-fastqc-start --run-fastqc-end --sequencer-source TruSeq3

# remove the intermediate output
cd /u/home/f/fquerdas/bablab/data/mbb/microbiome/w1_kneaddata 
find . -type f -name "${1%%_*}*" ! \( -path './fastqc/*' -o \( -name '*_paired_2*' -o -name '*_paired_1*' -o -name '*log*' -o -name '*_kneaddata.fastq' \) \) -print0 | xargs -0 -I {} rm -v {}

# echo job info on joblog:
echo " "
echo "Job $JOB_ID ended on:   " `hostname -s`
echo "Job $JOB_ID ended on:   " `date `
echo " "

