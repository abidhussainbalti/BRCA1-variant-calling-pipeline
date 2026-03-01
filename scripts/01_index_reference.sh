#!/bin/bash
# BWA index - prepares reference for fast alignment

cd ../inputs

echo "Indexing BRCA1 reference with BWA..."
bwa index brca1_reference.fa > ../logs/01_index.log 2>&1

echo "✅ Index complete:"
ls -lh brca1_reference.fa*
