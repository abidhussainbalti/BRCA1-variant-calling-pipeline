#!/bin/bash
# BWA mem - aligns reads to reference

cd ../inputs

echo "Aligning reads to BRCA1 with BWA..."
bwa mem brca1_reference.fa \
    simulated_reads_1.fq simulated_reads_2.fq \
    > ../results/alignment.sam 2> ../logs/02_align.log

echo "✅ Alignment complete:"
ls -lh ../results/alignment.sam
