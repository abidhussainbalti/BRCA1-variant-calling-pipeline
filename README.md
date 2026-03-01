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

## 🔧 Tools & Methods

**Pipeline stages:**
1. BWA - Sequence alignment (read mapping)
2. Samtools - BAM conversion, sorting, indexing
3. bcftools - Variant calling (SNP/indel detection)
4. bcftools - Filtering (quality control)

**Result:** 50 high-quality variants detected

---

## 🚀 Quick Start
```bash
# 1. Clone and setup
cd ~/nust-genomics-variant-calling

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

## 📈 Results

- **Raw variants called:** 50
- **Filtered variants (QUAL>50, DP>20):** 50
- **Output files:**
  - `raw_variants.vcf` - All variant calls
  - `filtered_variants.vcf` - High-quality variants
  - `alignment.bam` - Aligned reads (binary format)

---

## 📚 References

1. Li, H., & Durbin, R. (2009). Fast and accurate short read alignment with Burrows-Wheeler transform. *Bioinformatics*, 25(14), 1754-1760.
2. Li, H., et al. (2009). The Sequence Alignment/Map format and SAMtools. *Bioinformatics*, 25(16), 2078-2079.
3. BRCA1 gene: https://www.ncbi.nlm.nih.gov/grc/human/seqreg?rgn=17:41196312-41277500

---

**Author:** Abid Hussain | March 1, 2026

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

