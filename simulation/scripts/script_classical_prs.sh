mkdir results
mkdir results/classical
mkdir results/classical/thin
mkdir results/classical/just

p_values=("1" "0.1" "1e-2" "1e-3" "1e-4" "1e-5" "1e-6" "1e-7" "5e-8")

for p in "${p_values[@]}"; do

    ./ldak --thin-tops results/classical/thin/thin$p \
        --bfile data/validation/samples \
        --pvalues linreg/linreg.pvalues \
        --cutoff $p \
        --window-prune .1 --window-kb 1000 \
        --keep data/test.set \
        --allow-many-samples YES \
        --max-threads 4

    ./ldak --calc-scores results/classical/thin/thin$p \
        --scorefile linreg/linreg.score \
        --bfile data/validation/samples \
        --pheno data/samples.pheno \
        --extract results/classical/thin/thin$p.in \
        --power 0

    awk < linreg/linreg.pvalues -v p=$p '($2<p){print $1}' > results/classical/just/just$p.in

    ./ldak --calc-scores results/classical/just/just$p \
        --bfile data/validation/samples \
        --pheno data/samples.pheno \
        --extract results/classical/just/just$p.in \
        --power 0 \
        --scorefile linreg/linreg.score

done

grep Score_1 {results/classical/just/just,results/classical/thin/thin}{5e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,0.1,1}.cors | \
    awk '{print $2}' > results/classical/results.txt
