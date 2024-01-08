# Simulate data
num_snps=10000
num_samples=10000

# Simulate phenotype
power=-1
#power=-0.25
heritability=0.8
num_pheno=1
causal_snps=200
prevalence=0.1

rm -rf data
mkdir data

# Make simulated data and simulated phenotype
./ldak --make-snps data/samples \
    --num-samples $num_samples \
    --num-snps $num_snps

./ldak --make-phenos data/samples \
    --bfile data/samples \
    --ignore-weights YES \
    --power $power \
    --her $heritability \
    --num-phenos $num_pheno \
    --num-causals $causal_snps \
    --prevalence $prevalence

# Split dataset
val=0.1
n_val=$(echo "$num_samples*$val" | bc | xargs printf "%.0f\n")

# Specifify the test set
shuf data/samples.fam | tail -n $n_val > data/test.set

# Create train dataset and validation dataset
mkdir data/train
mkdir data/validation

./ldak --make-bed data/train/samples --bfile data/samples --remove data/test.set
./ldak --make-bed data/validation/samples --bfile data/samples --keep data/test.set