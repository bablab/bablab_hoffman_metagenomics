# bablab_hoffman_metagenomics
Scripts to run biobakery wmgx workflow with MBB metagenomics data on hoffman2

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
