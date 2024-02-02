# bablab_hoffman_metagenomics
Scripts to run biobakery wmgx workflow with MBB metagenomics data on hoffman2. Written by Fran Querdasi and Naomi Gancz

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
To process all the samples at the same time, for loop commands were run which run one job per sample. 
For kneaddata, the following was run in the raw data folder:
```bash
for f in *R1_001.fastq.gz;
  do name=$(basename $f R1_001.fastq.gz); qsub ../../scripts/run_kneaddata_forloop.sh ${name}R1_001.fastq.gz ${name}R2_001.fastq.gz; done
```
For metaphlan, from the folder with kneaddata outputs (forward and reverse reads merged):
```bash
for f in *_kneaddata.fastq;
do name=$(basename $f _kneaddata.fastq);
qsub ../scripts/run_metaphlan_merged.sh ${name}_kneaddata.fastq;
done
```
For humann, from the folder with kneaddata outputs (forward and reverse reads merged):
```bash
for file in *fastq; do qsub ../scripts/run_humann.sh $file; done 
```

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
To normalize abundances within sample (i.e., to account for uneven sequencing depth between samples):
1) Load biobakery environment
2) cd to scripts folder
3) Run humann_normalize_loop.sh by doing:
```bash
./humann_normalize_loop.sh
```
Note: if you get an error saying permissions denied, you need to make it executable by running: `chmod +x humann_normalize_loop.sh`
