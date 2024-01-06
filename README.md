# bablab_hoffman_metagenomics
Scripts to run biobakery wmgx workflow with MBB metagenomics data on hoffman2

## Load the hoffman-wide biobakery software
```bash
module load python
export BIOBAKERY_WORKFLOWS_DATABASES=/u/local/apps/BIOBAKERY/biobakery_workflows_databases
source /u/local/apps/PYTHON-VIRT-ENVS/3.9.6/biobakery/bin/activate
export PATH=/u/local/apps/TRF/4.09.1/bin:$PATH
module load samtools
```
As of Jan 2024, this version has kneaddata v0.10.0, humann v3.7, and metaphlan v4.0.6. 
Kneaddata was downgraded from the most updated (v11) in order to get paired end read processing to run correctly. 

## Information on how to submit jobs to run these scripts
Coming soon

## Commands run manually after kneaddata
Coming soon

## Commands run manually after metaphlan
To merge all profiled metagenomes:
1) Load biobakery environment
2) Run:
```bash
cd bablab/data/mbb/microbiome/w1_metaphlan_output
mkdir combined #make a folder for all combined output
merge_metaphlan_tables.py *metagenome.txt > combined/MBB_w1_merged_abundance_table.txt
```

## Commands run manually after humann
Coming soon
