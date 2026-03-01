#!/bin/bash
# SnpEff - annotate variants with functional impact

cd ../results/vcf

echo "Annotating variants with SnpEff..."
snpEff -c /path/to/snpEff/snpEff.config \
    -stats annotated_variants.html \
    hg38 filtered_variants.vcf \
    > annotated_variants.vcf 2> ../../logs/06_annotate.log

echo "✅ Annotation complete:"
ls -lh annotated_variants.vcf
