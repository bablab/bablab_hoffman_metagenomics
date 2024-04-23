# this script will remove the pathways that are broken down by gene 
# to allow for merging sample data (otherwise get memory issue)

# load library
library(tidyverse)

# get a list of all the pathway abundance files
fileslist <- list.files(path="../w1_humann_output/", pattern="pathabundance.tsv")

# for each file, remove rows that have "|" in name
for (x in fileslist) {
  setwd('../w1_humann_output')
  t <- read_tsv(x) #read file
  t <- t[!grepl("\\|",t$`# Pathway`),]
  write_tsv(t, paste(gsub('\\.tsv','',x),'_rpk_reduced.tsv', sep='')) # write these into a folder
}

# follow up with this merging code in terminal
# humann_join_tables -i . -o combined/mbb_w1_pathways_rpk.tsv --file_name pathabundance_rpk_reduced
