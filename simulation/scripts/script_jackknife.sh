p_values=("1" "0.1" "1e-2" "1e-3" "1e-4" "1e-5" "1e-6" "1e-7" "5e-8")

for p in "${p_values[@]}"; do
    
    ./ldak --jackknife results/classical/thin/thin$p \
        --profile results/classical/thin/thin$p.profile \
        --num-blocks 200 \
        --AUC YES \
        --prevalence 0.1

    
    ./ldak --jackknife results/classical/just/just$p \
        --profile results/classical/just/just$p.profile \
        --num-blocks 200 \
        --AUC YES \
        --prevalence 0.1

done

grep '1 Liability_squared_correlation' {results/classical/just/just,results/classical/thin/thin}{5e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,0.1,1}.jack | \
    awk '{print $3}' > results/classical/liab.txt

grep '1 Area_under_curve' {results/classical/just/just,results/classical/thin/thin}{5e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,0.1,1}.jack | \
    awk '{print $3}' > results/classical/auc.txt