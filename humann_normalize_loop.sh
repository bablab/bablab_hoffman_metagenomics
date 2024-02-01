#!/bin/sh
# use this script to run total sum squares normalization (i.e. for maaslin2 input) on
## humann output

# apply loop to files (gene families, path abundance, path coverage for each sample) in humann output dir
for FILE in ../w1_humann_output/*.tsv;


do

if [[ $FILE != *"coverage"* ]]; then 

echo "running " "$FILE";

# normalize to relative abundance (reads per million; '%%.*' removes extension)
humann_renorm_table -i $FILE -o ${FILE/.tsv/}_copiespermillion.tsv -u cpm

fi

done
