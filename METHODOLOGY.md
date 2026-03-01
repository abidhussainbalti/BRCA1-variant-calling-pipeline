# Variant Calling Methodology - Scientific Explanation

## 1. What Are Genetic Variants?

**Definition:** Differences in DNA sequence between individuals at the same genomic location.

**Types:**
- **SNP (Single Nucleotide Polymorphism):** One base changed (A→G, T→C, etc.)
- **Indel:** Insertion or deletion of bases
- **Structural variant:** Large segments inserted/deleted/rearranged

**Biological significance:**
- Drive evolution and adaptation
- Cause genetic diseases (e.g., BRCA1 mutations cause cancer risk)
- Distinguish between individuals (fingerprinting)

---

## 2. Why Sequence BRCA1?

**BRCA1 gene:**
- 193,689 bp on chromosome 17
- Encodes DNA repair protein
- Mutations → breast/ovarian cancer risk
- ~200+ known disease-causing variants
- Perfect for teaching variant detection

---

## 3. Sequencing & Reads - How It Works

**Real process:**
```
Patient DNA → Break into fragments → Read fragments on machine
             → Millions of short reads (100 bp each)
             → Map back to reference → Find differences
```

**Our simulated process:**
- Reference: BRCA1 gene
- Create "patient" version with 50 known mutations
- Generate reads from both: 50% reference, 50% mutated
- This creates realistic 0/1 (heterozygous) genotypes

**Why simulated?**
- ✅ Ethical (no patient data)
- ✅ Reproducible (same data every run)
- ✅ Controllable (know true variants)
- ✅ Validatable (can verify accuracy)
- ✅ Fast (no weeks of sequencing)

---

## 4. Variant Calling Pipeline - Each Step Explained

### Step 1: BWA Indexing (01_index_reference.sh)

**What:** Create searchable index of reference sequence

**How:** Burrows-Wheeler Transform (BWT)
- Compresses reference for fast searching
- Creates multiple index files (.bwt, .sa, .pac, etc.)
- Enables finding read matches in seconds

**Output:** Reference index files

---

### Step 2: BWA Alignment (02_align_reads.sh)

**What:** Map each read to reference genome

**Problem:** 50,000 reads × 100 bp = 5 million bases to search
- Naive approach: Compare each read to all 193,689 bp = impossibly slow
- Solution: Use BWT index

**How BWA mem works:**
```
For each read:
1. Find seed matches (exact matches, short regions)
2. Extend seeds to full alignments
3. Output position on reference + quality score
```

**Output:** SAM file (Sequence Alignment/Map)
- Text format showing where each read mapped
- Contains: read name, position, CIGAR string (how it aligns), sequence

---

### Step 3: Samtools Sorting (03_sort_bam.sh)

**What:** Convert SAM to binary BAM, sort by position, create index

**Why convert SAM→BAM?**
- SAM: text format, 29 MB for our data
- BAM: binary compressed, 1.7 MB (95% smaller)
- Faster to process, easier to index

**Why sort?**
- Variants called by examining each position in order
- Sorted BAM enables random access to any region
- Index (.bai) = "table of contents" for fast lookups

**Output:** alignment.bam + alignment.bam.bai

---

### Step 4: bcftools Variant Calling (04_call_variants.sh)

**What:** Find positions where reads differ from reference

**Algorithm:**
```
For each position in reference:
  Count reads with A, T, G, C
  If consistent difference from reference:
    Call variant
  Calculate quality score (QUAL field)
  Estimate depth (DP = number of reads at that position)
```

**Quality scoring (PHRED):**
- QUAL = -10 × log10(error probability)
- QUAL 50 = 0.001% error probability = 99.999% confident
- QUAL 20 = 1% error probability = 99% confident

**Output:** raw_variants.vcf (VCF = Variant Call Format)

---

### Step 5: bcftools Filtering (05_filter_vcf.sh)

**What:** Keep only confident, well-supported variants

**Criteria:**
- `QUAL > 50`: High confidence calls only
- `INFO/DP > 20`: At least 20 reads support variant

**Rationale:**
- QUAL < 50: Likely sequencing error
- DP < 20: Insufficient evidence (could be random noise)

**Output:** filtered_variants.vcf (high-quality set)

---

## 5. VCF Format Explained

**Example variant line:**
```
NG_005905.2  2704  .  T  C  152.392  .  DP=53;...  GT:PL  0/1:185,0,180
```

**Fields:**
- `CHROM`: Chromosome (NG_005905.2 = BRCA1)
- `POS`: Position in reference (2704)
- `REF`: Reference base (T)
- `ALT`: Alternate/mutated base (C)
- `QUAL`: Quality score (152.392 = very confident)
- `DP`: Depth (53 reads support this position)
- `GT`: Genotype (0/1 = heterozygous = one copy mutated, one normal)

---

## 6. Why Our Results = 50 Variants

**Truth:** We created 50 variant positions in simulated data
- 50% of reads from reference (normal allele)
- 50% from mutated version (alternate allele)
- Creates 0/1 heterozygous genotypes

**Result:** All 50 variants detected with high confidence
- QUAL 150+ (very high)
- DP 40-60 (well-supported)
- Perfect accuracy (100%)

**Real data:** Would have:
- Multiple samples (lower QUAL, mixed frequencies)
- Unknown true variants (can't validate accuracy)
- Artifacts and errors (lower pass rate)

---

## 7. Biological Interpretation

**What variants mean:**
- Position 2704: T→C substitution in BRCA1
- If this affects protein: could be harmful
- Need annotation (SnpEff) to determine impact

**Impact types (not done here, but important):**
- **Missense:** Changes amino acid → potentially harmful
- **Synonymous:** Doesn't change amino acid → usually neutral
- **Frameshift:** Shifts reading frame → usually harmful
- **Stop gain:** Creates early stop codon → loss of function

---

## 8. Validation - How We Know It Works

**Standard validation metrics:**
- **Sensitivity:** % of true variants found = 100% (found 50/50)
- **Specificity:** % of called variants are real = 100% (all 50 are real)
- **False positive rate:** 0%
- **False negative rate:** 0%

**Real data validation harder because true variants unknown.**

---

**Reference:** Li, H., & Durbin, R. (2009). Bioinformatics, 25(14).

---

## 9. Colab Analysis & Visualization

**Why Google Colab?**
- ✅ Interactive analysis environment
- ✅ Easy to reproduce
- ✅ Direct visualization generation
- ✅ No local software installation needed

**Analysis Steps (Colab Notebook):**

### Step 1: Parse VCF File
- Read filtered_variants.vcf
- Extract: Position, Reference, Alternate, Quality, Depth
- Load into Pandas DataFrame for analysis

### Step 2: Generate Statistics
- Calculate quality metrics (min, max, mean, median)
- Calculate depth metrics (min, max, mean)
- Identify genomic range covered

### Step 3: Create Visualizations

**Panel 1: Variant Position Distribution**
- Shows WHERE variants located on BRCA1
- X-axis: Genomic position (bp)
- Visualization: Scatter plot of all variant positions
- Insight: Are variants clustered or evenly distributed?

**Panel 2: Quality Score Histogram**
- Shows CONFIDENCE in variant calls
- X-axis: QUAL score (0-255)
- Y-axis: Number of variants at each quality level
- Red line: Average quality
- Insight: Are most calls high-confidence?

**Panel 3: Sequencing Depth Histogram**
- Shows READ SUPPORT for variants
- X-axis: Depth (coverage)
- Y-axis: Number of variants
- Red line: Average depth
- Insight: Sufficient coverage across genome?

**Panel 4: Quality vs Depth Scatter**
- Shows RELATIONSHIP between confidence and coverage
- X-axis: Depth (reads)
- Y-axis: Quality (confidence)
- Color gradient: Position on genome
- Insight: Does more coverage = higher quality?

**Summary Table:**
- All key statistics in one image
- Quality range, depth range, genomic coverage
- Reference metrics for interpretation

---

## 10. Results Interpretation

**Our Results (50 Variants):**

| Metric | Value | Meaning |
|--------|-------|---------|
| Total Variants | 50 | Perfect detection (planted 50 variants) |
| Quality Range | 104-153 | All high-confidence calls |
| Depth Range | 37-72x | Good read support |
| Sensitivity | 100% | Found all true variants |
| Specificity | 100% | No false positives |

**What This Means:**
- ✅ Pipeline working correctly
- ✅ Variant calling algorithm robust
- ✅ Quality filtering appropriate
- ✅ Results reproducible

**Real Data Would Show:**
- Variable quality scores (some low-confidence)
- Mixed depth (some regions undercovered)
- Unknown variants (can't validate accuracy)
- Population variation (multiple samples)

---

## 11. Quality Metrics Explained

**QUAL Score (Phred Quality):**
```
QUAL = -10 × log10(P_error)

QUAL 10  = 90% confidence (1 in 10 chance of error)
QUAL 20  = 99% confidence (1 in 100 chance)
QUAL 50  = 99.999% confidence (1 in 100,000)
QUAL 100+ = Extremely high confidence
```

**Depth (DP):**
```
DP = Number of reads at that position

DP 10   = Low coverage (risky)
DP 30   = Good coverage (standard)
DP 100+ = High coverage (very confident)
```

**Combined Interpretation:**
- High QUAL + High DP = Very confident variant ✅
- High QUAL + Low DP = Possible artifact ⚠️
- Low QUAL + High DP = Sequencing error ⚠️
- Low QUAL + Low DP = Don't trust ❌

