#!/bin/bash
python3 << 'PYTHON'
import random

# Read reference
ref_seq = ""
with open("brca1_reference.fa") as f:
    for line in f:
        if not line.startswith(">"):
            ref_seq += line.strip()

print(f"Reference: {len(ref_seq)} bp")
print("Creating variant reference and generating reads...")

# Step 1: Create variant positions in reference
random.seed(42)
num_variants = 50  # 50 variants across genome
variant_positions = sorted(random.sample(range(1000, len(ref_seq)-1000), num_variants))

# Create mutated reference with consistent variants
mut_ref = list(ref_seq)
bases = ['A', 'T', 'G', 'C']

variant_map = {}
for pos in variant_positions:
    current = mut_ref[pos]
    mutants = [b for b in bases if b != current]
    new_base = random.choice(mutants)
    mut_ref[pos] = new_base
    variant_map[pos] = (current, new_base)

mut_ref = ''.join(mut_ref)

print(f"Created {len(variant_positions)} variant positions")

# Step 2: Generate reads from BOTH references
# 50% from reference, 50% from mutated = heterozygous calls
num_reads = 50000
reads_per_ref = num_reads // 2

with open("simulated_reads_1.fq", "w") as f1, open("simulated_reads_2.fq", "w") as f2:
    read_id = 0
    
    # Reads from reference
    for i in range(reads_per_ref):
        pos = random.randint(0, len(ref_seq) - 200)
        read1 = ref_seq[pos:pos+100]
        read2 = ref_seq[pos+100:pos+200]
        
        f1.write(f"@read_{read_id}/1\n{read1}\n+\n{'I'*100}\n")
        f2.write(f"@read_{read_id}/2\n{read2}\n+\n{'I'*100}\n")
        read_id += 1
    
    # Reads from mutated reference
    for i in range(reads_per_ref):
        pos = random.randint(0, len(mut_ref) - 200)
        read1 = mut_ref[pos:pos+100]
        read2 = mut_ref[pos+100:pos+200]
        
        f1.write(f"@read_{read_id}/1\n{read1}\n+\n{'I'*100}\n")
        f2.write(f"@read_{read_id}/2\n{read2}\n+\n{'I'*100}\n")
        read_id += 1

print(f"✅ Generated {num_reads} reads (50% ref, 50% mutated)")
PYTHON
