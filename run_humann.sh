#### run_humann.sh START ###
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
humann -i $1 -o /u/home/f/fquerdas/bablab/data/mbb/microbiome/w1_humann_output/ --threads 20 --input-format fastq

# remove all of the temp output files besides the log file
cd /u/home/f/fquerdas/bablab/data/mbb/microbiome/w1_humann_output/ 
find . -type f ! \( -name '*log*' -o -name '*genefamilies*' -o -name '*pathabundance*' -o -name '*pathcoverage*' \) -print0 | xargs -0 -I {} rm -v {}

# move the log file into the main folder
cd ${1%%_*}_kneaddata_humann_temp
mv *log ../

# delete the extra temp directory (now empty)
cd ..
rmdir ${1%%_*}_kneaddata_humann_temp

# echo job info on joblog:
echo " "
echo "Job $JOB_ID ended on:   " `hostname -s`
echo "Job $JOB_ID ended on:   " `date `
echo " "
