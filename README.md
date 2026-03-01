# NUST Genomics: Variant Calling Pipeline
## Task 5 - Identifying Genetic Variants in BRCA1 Gene

---

## 📋 Project Overview

**Course:** Genomics (NUST) | **Due:** March 4, 2026 | **Student:** Abid Hussain

**Objective:** Implement variant calling pipeline to detect SNPs and indels in BRCA1 gene using next-generation sequencing data (simulated).

---

## 📊 Dataset

- **Reference:** BRCA1 gene (NG_005905.2) - 193,689 bp
- **Simulated reads:** 50,000 paired-end reads (100 bp each)
- **Variants introduced:** 50 known variants for testing
- **Coverage:** ~25-60x depth of coverage

---

## 📁 Repository Structure
```
nust-genomics-variant-calling/
├── README.md                          # This file
├── METHODOLOGY.md                     # Scientific explanation
├── requirements.txt                   # Python dependencies
│
├── inputs/
│   ├── brca1_reference.fa            # BRCA1 reference (uploaded)
│   ├── brca1_reference.fa.*          # BWA index files (generated)
│   ├── generate_simulated_reads.sh   # Script to create reads
│   ├── simulated_reads_1.fq          # Forward reads (generated)
│   └── simulated_reads_2.fq          # Reverse reads (generated)
│
├── scripts/
│   ├── 01_index_reference.sh         # BWA index
│   ├── 02_align_reads.sh             # BWA alignment
│   ├── 03_sort_bam.sh                # Samtools sort/index
│   ├── 04_call_variants.sh           # bcftools variant calling
│   ├── 05_filter_vcf.sh              # bcftools filtering
│   └── 06_annotate_variants.sh       # SnpEff annotation
│
├── results/
│   ├── alignment.sam                 # SAM alignment (intermediate)
│   ├── alignment.bam                 # BAM alignment (binary)
│   ├── alignment.bam.bai             # BAM index
│   ├── analysis/
│   │   ├── variant_summary.csv       # Variant statistics
│   │   └── figures/
│   │       ├── variant_analysis.png           # 4-panel visualization
│   │       └── variant_summary_table.png      # Summary statistics
│   └── vcf/
│       ├── raw_variants.vcf          # Unfiltered variants
│       └── filtered_variants.vcf     # High-quality variants
│
├── logs/
│   ├── 01_index.log
│   ├── 02_align.log
│   ├── 03_sort.log
│   ├── 04_variants.log
│   └── 05_filter.log
│
└── colab/
    └── variant_analysis_brca1ipynb.ipynb   # Analysis notebook
```

**Legend:**
- ✅ Uploaded to GitHub
- 🔄 Generated during pipeline execution
- 📊 Output results

---

## 🧬 Data Generation - How Simulated Reads Are Created

### Reference Dataset
- **File:** `inputs/brca1_reference.fa` (81 KB)
- **Source:** NCBI Nucleotide (NG_005905.2)
- **Content:** Complete BRCA1 gene sequence (193,689 bp)
- **Purpose:** Ground truth for variant calling

### Simulated Read Generation
**Script:** `inputs/generate_simulated_reads.sh`

**What it does:**
```
Step 1: Read reference BRCA1 sequence
Step 2: Create "patient" version with 50 known mutations
   - Random positions across genome
   - Single nucleotide changes (SNPs)
   - Creates variant reference
   
Step 3: Generate paired-end reads
   - 50% from original reference (normal alleles)
   - 50% from mutated version (alternate alleles)
   - Result: Heterozygous (0/1) genotypes
   
Step 4: Output FASTQ format
   - simulated_reads_1.fq (forward reads, 100 bp each)
   - simulated_reads_2.fq (reverse reads, 100 bp each)
   - Total: 50,000 paired-end read pairs
```

**Why this approach?**
- ✅ Simulates realistic sequencing scenario
- ✅ 50% reference + 50% mutant = heterozygous calls
- ✅ Known variants for validation (100% sensitivity/specificity)
- ✅ Fast and reproducible

**Generated files:**
- `simulated_reads_1.fq` (11 MB) - Forward reads
- `simulated_reads_2.fq` (11 MB) - Reverse reads

---

## 🔧 Tools & Methods

**Pipeline stages:**
1. **BWA** - Sequence alignment (read mapping)
2. **Samtools** - BAM conversion, sorting, indexing
3. **bcftools** - Variant calling (SNP/indel detection)
4. **bcftools** - Filtering (quality control)

**Result:** 50 high-quality variants detected

---

## 🚀 Quick Start
```bash
# 1. Clone repository
git clone https://github.com/abidhussainbalti/BRCA1-variant-calling-pipeline.git
cd BRCA1-variant-calling-pipeline

# 2. Generate simulated reads (creates .fq files)
bash inputs/generate_simulated_reads.sh

# 3. Index reference
bash scripts/01_index_reference.sh

# 4. Run alignment pipeline
bash scripts/02_align_reads.sh
bash scripts/03_sort_bam.sh
bash scripts/04_call_variants.sh
bash scripts/05_filter_vcf.sh

# 5. View results
cat results/vcf/filtered_variants.vcf
```

**Expected runtime:** ~10-15 minutes

---

## 📊 Analysis Results

**Variants Detected:** 50 high-quality SNPs
- Quality scores: 104 - 153
- Sequencing depth: 37 - 72x
- Genomic range: 193,689 bp covered

---

## 📈 Visualizations (Google Colab)

**Colab Notebook:** `colab/variant_analysis_brca1ipynb.ipynb`

**Generated Figures:**
1. `variant_analysis.png` - 4-panel analysis
   - Panel 1: Variant positions across BRCA1
   - Panel 2: Quality score distribution
   - Panel 3: Read coverage distribution  
   - Panel 4: Quality vs Depth relationship

2. `variant_summary_table.png` - Statistics table
   - Total variants: 50
   - Quality metrics (min/max/mean)
   - Depth metrics (min/max/mean)
   - Genomic coverage range

**How to Reproduce:**
1. Open `colab/variant_analysis_brca1ipynb.ipynb` in Google Colab
2. Upload `results/vcf/filtered_variants.vcf`
3. Run all cells
4. Download PNG visualizations

---

## 📚 References

1. Li, H., & Durbin, R. (2009). Fast and accurate short read alignment with Burrows-Wheeler transform. *Bioinformatics*, 25(14), 1754-1760.
2. Li, H., et al. (2009). The Sequence Alignment/Map format and SAMtools. *Bioinformatics*, 25(16), 2078-2079.
3. BRCA1 gene: https://www.ncbi.nlm.nih.gov/grc/human/seqreg?rgn=17:41196312-41277500

---

**Author:** Abid Hussain | March 1, 2026
