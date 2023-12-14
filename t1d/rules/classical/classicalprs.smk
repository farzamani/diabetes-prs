rule get_pvalue_scorefile:
    input:
        sumstats = "data/sumstats/sumstats.txt"
    output:
        pvalue = "data/sumstats/pvalue.txt",
        scorefile = "data/sumstats/scorefile.txt"
    threads:
        1
    resources:
        mem_mb = 1000,
        runtime = 720
    shell:
        """
        cat {input.sumstats} | awk '{print $1,$7}' > {output.pvalue}
        cat {input.sumstats} | awk '{print $1,$7}' > {output.pvalue}
        """

rule classical_prs_just:
    input:
        pvalue = "data/sumstats/pvalue.txt"
    output:
        just = ,
        thin = ,
        results = "results/classical/results.txt"
    params:
        bfile = "data/target/geno2",
        pheno = "data/t1d.pheno",
    threads:
        4
    resources:
        mem_mb = get_mem_high,
        runtime = 720
    shell:
        """
        p_values=("1" "0.1" "1e-2" "1e-3" "1e-4" "1e-5" "1e-6" "1e-7" "5e-8")

        for p in "${p_values[@]}"; do

            ./ldak --thin-tops results/classical/thin/thin$p \
                --bfile {params.bfile} \
                --pvalues {input.pvalue} \
                --cutoff $p \
                --window-prune .1 \
                --window-kb 1000

            ./ldak --calc-scores results/classical/thin/thin$p \
                --scorefile linreg/linreg.score \
                --bfile {params.bfile} \
                --pheno {params.pheno} \
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

        grep Score_1 {results/classical/just/just,results/classical/thin/thin}{5e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,0.1,1}.cors \
            | awk '{print $2}' > results/classical/results.txt
        """