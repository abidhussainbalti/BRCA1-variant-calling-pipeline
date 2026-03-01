#!/bin/bash
# Samtools - convert SAM to BAM, sort and index

cd ../results

echo "Converting SAM to BAM and sorting..."
samtools view -b alignment.sam | samtools sort -o alignment.bam - > ../logs/03_sort.log 2>&1

echo "Indexing BAM file..."
samtools index alignment.bam >> ../logs/03_sort.log 2>&1

echo "✅ BAM complete:"
ls -lh alignment.bam*
