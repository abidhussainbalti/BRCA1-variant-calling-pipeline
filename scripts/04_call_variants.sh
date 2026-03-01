#!/bin/bash
# bcftools - call variants (SNPs and indels)

cd ../results

echo "Calling variants from BAM..."
bcftools mpileup -f ../inputs/brca1_reference.fa alignment.bam | \
bcftools call -mv -o vcf/raw_variants.vcf > ../logs/04_variants.log 2>&1

echo "✅ Variant calling complete:"
ls -lh vcf/raw_variants.vcf
