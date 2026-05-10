# EvoR <img src="https://github.com/user-attachments/assets/91d270e6-345d-4a06-9811-59e9b7272486" align="right" width="200" />

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.20113473.svg)](https://doi.org/10.5281/zenodo.20113473)

**EvoR** is an R interface for the **Evo2 Genomic Foundation Model** (built by the Arc Institute). It allows researchers to leverage state-of-the-art biological AI for sequence generation, scoring, and embedding extraction directly within the R environment.

## 🚀 Key Features

- **Generation:** Generate long DNA sequences (up to 1M bp) with biological context.
- **Scoring (VEP):** Calculate log-likelihood scores to predict the effect of variants (e.g., in Type 2 Diabetes research).
- **Embeddings:** Extract 4096-dimensional vectors for deep learning and regulatory pattern recognition.

## 📦 Installation

```r
# Install development version from GitHub
# install.packages("devtools")
devtools::install_github("BDB-Genomics/EvoR")
```

## 🛠️ Quick Start

### 1. Set your API Key
You need an NVIDIA BioNeMo API key to use EvoR.
```r
Sys.setenv(NVIDIA_API_KEY = "your_key_here")
```

### 2. Get Variant Effect Scores
```library(EvoR)

# Query the model
response <- evo2_query("ACTG...")

# Extract scores
scores <- evo2_get_score(response)
print(head(scores))
```

### 3. Extract Embeddings
```r
# Get high-dimensional vectors for a sequence
emb_response <- evo2_query_embeddings("ACTG...")
embeddings <- evo2_get_embeddings(emb_response)

# embeddings is now an R matrix [nucleotides x 4096]
dim(embeddings)
```

## 📄 Reference
Evo 2 Nature paper: [https://www.nature.com/articles/s41586-026-10176-5](https://www.nature.com/articles/s41586-026-10176-5)

---
Developed as part of the **BDB-Genomics** ecosystem.
