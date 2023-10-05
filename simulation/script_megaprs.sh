mkdir results
mkdir results/megaprs

models=("lasso" "ridge" "bolt" "bayesr")

for model in "${models[@]}"; do
    
    mkdir results/megaprs/$model
    out="results/megaprs/$model/$model"

    ./ldak --mega-prs $out \
        --model $model \
        --summary linreg/linreg.summaries \
        --ind-hers results/snphers/gcta.ind.hers \
        --cors results/cors/cors \
        --check-high-LD NO \
        --cv-proportion .1 \
        --window-kb 1000 \
        --allow-ambiguous YES

    ./ldak --calc-scores results/megaprs/$model/score \
        --scorefile results/megaprs/$model/$model.effects \
        --bfile data/validation/samples \
        --pheno data/samples.pheno \
        --power 0

done

