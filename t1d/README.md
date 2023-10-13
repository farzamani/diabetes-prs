# Polygenic Risk Scoring for Type-1 Diabetes
Script for calculating polygenic risk score for Type-1 Diabetes.

## Directory Structure

```
t1d/
├── data
├── reference
├── scripts
└── results
```

## Dataset details: 
https://www.ebi.ac.uk/gwas/studies/GCST90043635

How to download:

```bash
cd data/raw
wget https://yanglab.westlake.edu.cn/data/fastgwa_data/UKBbin/250.1_PheCode.v1.0.fastGWA.gz
```

We will predict on this `bgen` data:

```bash
ln -s /home/farzamani/snpher/faststorage/biobank/geno_plink geno_plink
```