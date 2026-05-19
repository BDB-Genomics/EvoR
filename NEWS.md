# Changelog

All notable changes to the EvoR package are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this package adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.99.0] - 2026-05-19

### Fixed
- Version mismatch across `DESCRIPTION`, `CITATION.cff`, and `inst/CITATION` (now consistently `0.99.0`)

### Changed
- Standardized `DESCRIPTION` Authors@R field continuation indentation

### Docs
- Added DeepWiki badge to `README.md`
- Updated README section headers and logo placement

## [0.1.0] - 2026-05-06

### Added
- **Core Functions:**
  - `evo2_query()` — Sequence generation via NVIDIA BioNeMo Evo2 API
  - `evo2_get_score()` — Extract confidence scores (sampled_probs) for Variant Effect Prediction
  - `evo2_query_embeddings()` — Query forward pass for sequence embeddings
  - `evo2_get_embeddings()` — Decode base64-encoded NumPy embeddings
  - `%||%` — Internal null-coalescing operator
- **Package Infrastructure:**
  - `DESCRIPTION` file with full metadata (Bioconductor-compatible)
  - `NAMESPACE` with roxygen2-generated exports
  - Roxygen2 documentation for all exported functions
  - Vignette (`intro_to_evor.Rmd`) covering setup, generation, scoring, embeddings, and T2D workflow
- **Testing:**
  - Unit tests for all 4 exported functions using `testthat` (edition 3)
  - Mock-based testing (avoids live API calls)
- **Citation:**
  - `CITATION.cff` with Zenodo DOI (`10.5281/zenodo.20113473`)
  - `inst/CITATION` for R-level `citation("EvoR")` support
- **Security:**
  - `.gitignore` protecting `.env` and API key files
  - `SECURITY.md` with supported versions and contact info
  - `CODEOWNERS` for review routing
- **License:** Apache License 2.0