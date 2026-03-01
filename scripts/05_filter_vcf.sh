#!/bin/bash
# bcftools - filter variants for quality

cd ../results/vcf

echo "Filtering variants (QUAL>20, DP>5)..."
bcftools filter -i 'QUAL>20 && FORMAT/DP>5' \
    raw_variants.vcf > filtered_variants.vcf 2> ../../logs/05_filter.log

echo "✅ Filtering complete:"
ls -lh filtered_variants.vcf
