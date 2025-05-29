# bablab_hoffman_metagenomics
Scripts to run biobakery wmgx workflow with MBB metagenomics data on hoffman2. Scripts were written by Fran (Francesca) Querdasi and Naomi Gancz. :)

In addition to this repository and the two authors, when building upon this pipeline please acknowledge Dr. Raffaella D'Auria of OARC for her work installing the software on hoffman and troubleshooting related issues, and Julianne Yang for the important groundwork that she laid with using biobakery software on hoffman. If you do in fact use Hoffman2 to run any part of this software, please finally acknowledge the hoffman cluster with this text: "This work used computational and storage services associated with the Hoffman2 Shared Cluster provided by UCLA Office of Advanced Research Computing’s Research Technology Group.". Thank you!

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

If you would like to set up biobakery workflows with the same specifications as we installed on Hoffman, please refer to the document: `installation_requirements_for_biobakery.rtf` for dependencies and installation instructions. The file `requirements.txt` lists all of the software dependencies and versions required. 

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
For humann, before merging all samples, we needed to reduce the number of pathways specified in each file to avoid a memory issue. Since the raw output gives overall pathways as well as pathways broken down by each gene's contribution, we removed the more fine-grained broken down pathways (because they are not of interest). To do that:
1) Open an Rstudio GUI on hoffman by typing (on a Mac):
```bash
defaults write org.macosforge.xquartz.X11 enable_iglx -bool true
ssh -Y login_id@hoffman2.idre.ucla.edu
qrsh -l h_data=5G,h_rt=1:00:00 # open interactive session with 5G of data and 1 hour of runtime
module load Rstudio
rstudio & 
```
3) Open and run `humann_reduce_pathways.R`

To generate merged unstratified output (overall pathways and pathways broken down by each gene's conribution):
1) Request a computing session with 48GB of memory:
`qrsh -l h_rt=3:00:00,h_data=4G -pe shared 12`
2) Load biobakery environment
3) Navigate to w1_humann_output
4) Run: `humann_join_tables -i . -o combined/mbb_w1_pathways_rpk_unstrat.tsv --file_name pathabundance.tsv` 

To normalize abundances within sample (i.e., to account for uneven sequencing depth between samples):
1) Load biobakery environment
2) cd to scripts folder
3) Run humann_normalize_loop.sh by doing:
```bash
./humann_normalize_loop.sh
```
Note: if you get an error saying permissions denied, you need to make it executable by running: `chmod +x humann_normalize_loop.sh`

To regroup gene families to other functional categories:
1) Download mapping files:  `humann_databases --download utility_mapping full /u/home/f/fquerdas/bablab/data/mbb/microbiome/databases`
