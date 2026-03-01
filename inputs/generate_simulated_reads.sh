#!/bin/bash
# Generate simulated reads using Python (alternative to wgsim)

python3 << 'PYTHON'
import random
import sys

# Read reference
ref_seq = ""
with open("brca1_reference.fa") as f:
    for line in f:
        if not line.startswith(">"):
            ref_seq += line.strip()

print(f"Reference length: {len(ref_seq)} bp")
print(f"Generating 50,000 paired-end reads (100bp each)...")

random.seed(42)
num_reads = 50000

with open("simulated_reads_1.fq", "w") as f1, open("simulated_reads_2.fq", "w") as f2:
    for i in range(num_reads):
        # Random position in reference
        pos = random.randint(0, len(ref_seq) - 200)
        
        # Extract paired reads (forward and reverse)
        read1 = ref_seq[pos:pos+100]
        read2 = ref_seq[pos+100:pos+200]
        
        # Write FASTQ format
        f1.write(f"@read_{i}_1\n{read1}\n+\n{'I'*100}\n")
        f2.write(f"@read_{i}_2\n{read2}\n+\n{'I'*100}\n")

print("✅ Reads generated:")
print("  simulated_reads_1.fq")
print("  simulated_reads_2.fq")
PYTHON
