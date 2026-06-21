<img width="1983" height="793" alt="ChatGPT Image May 11, 2026, 02_09_50 AM" src="https://github.com/user-attachments/assets/89224cb3-029a-4fed-8619-8482bf1604a6" />

# EvoR: Genomic Foundation Models in R

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.20113473.svg)](https://doi.org/10.5281/zenodo.20113473)
[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/BDB-Genomics/EvoR)

**EvoR** is a lightweight R interface for the **Evo2 Genomic Foundation Model** (developed by the Arc Institute) via the NVIDIA BioNeMo API. It allows researchers to perform sequence generation, variant scoring, and high-dimensional embedding extraction natively in R.

---

## 🚀 Key Features

*   **Generation (`evo2_query`)**: Generate biological sequences (up to 1M bp) using deterministic or stochastic sampling.
*   **Scoring (`evo2_get_score`)**: Compute nucleotide-level log-probabilities for Variant Effect Prediction (VEP).
*   **Embeddings (`evo2_query_embeddings`, `evo2_get_embeddings`)**: Extract 4096-dimensional representation vectors for downstream ML modeling.

---

## 📦 Installation

Install the development version directly from GitHub:

```r
# install.packages("devtools")
devtools::install_github("BDB-Genomics/EvoR")
```

---

## 🔧 Setup

To query Evo2, you need an NVIDIA BioNeMo API key. Set it as an environment variable:

```r
Sys.setenv(NVIDIA_API_KEY = "your_nvidia_api_key_here")
```

---

## ⚡ Quick Start

Here is a complete end-to-end example workflow:

```r
library(EvoR)

# 1. Define a DNA sequence of interest
sequence <- "ATGCGTACGTAGCTAGCTAGCTAGCTAGC"

# 2. Query Evo2 for sequence generation & scoring
response <- evo2_query(sequence, num_tokens = 10)

# 3. Extract confidence/variant scoring
scores <- evo2_get_score(response)
print("Nucleotide log-probabilities:")
print(head(scores))

# 4. Extract sequence embeddings (forward pass)
emb_response <- evo2_query_embeddings(sequence)
embeddings <- evo2_get_embeddings(emb_response)

# The result is a numeric matrix [sequence_length x 4096]
print("Embeddings Matrix Dimensions:")
print(dim(embeddings))
```

---

## 📚 References

*   **Evo2 Nature Paper**: [Arc Institute / Nature (2026)](https://www.nature.com/articles/s41586-026-10176-5)
*   **Source Code**: [BDB-Genomics/EvoR](https://github.com/BDB-Genomics/EvoR)

---
Developed as part of the **BDB-Genomics** ecosystem.
