#!/bin/bash
# bcftools - filter variants (correct field names)

cd ../results/vcf

echo "Filtering variants (QUAL>50, INFO/DP>20)..."
bcftools filter -i 'QUAL>50 && INFO/DP>20' \
    raw_variants.vcf > filtered_variants.vcf 2> ../../logs/05_filter.log

echo "✅ Filtering complete"
