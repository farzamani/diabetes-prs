rule get_pvalue_scorefile:
    input:
        sumstats = "data/sumstats/sumstats.txt",
        snplist = "results/snps/snps.valid"
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
        awk 'NR==FNR{{valid[$1]; next}} $1 in valid' {input.snplist} {input.sumstats} | \
            awk -F '\\t' '{{print $1,$6}}' > {output.pvalue}
        
        echo "Predictor\tA1\tA2\tCentre\tALL" > {output.scorefile}
        awk 'NR==FNR{{valid[$1]; next}} $1 in valid' {input.snplist} {input.sumstats} | \
            awk -F '\\t' 'NR>1 {{print $1,$2,$3,"NA",$5}}' >> {output.scorefile}
        """

rule classical_prs_just:
    input:
        pvalue = "data/sumstats/pvalue.txt",
        scorefile = "data/sumstats/scorefile.txt"
    output:
        results = "results/classical/results.txt"
    params:
        bfile = "data/target/geno2",
        pheno = "data/t2d.pheno",
        snplist = "results/snps/snps.valid"
    threads:
        16
    resources:
        mem_mb = get_mem_high,
        runtime = 720
    shell:
        """
        mkdir -p results/classical
        mkdir -p results/classical/just
        mkdir -p results/classical/thin

        p_values=("1" "0.1" "1e-2" "1e-3" "1e-4" "1e-5" "1e-6" "1e-7" "5e-8")

        for p in "${{p_values[@]}}"; do

            ./ldak --thin-tops results/classical/thin/thin$p \
                --bfile {params.bfile} \
                --pvalues {input.pvalue} \
                --cutoff $p \
                --window-prune 0.05 \
                --window-kb 1000 \
                --allow-many-samples YES \
                --max-threads {threads}

            ./ldak --calc-scores results/classical/thin/thin$p \
                --scorefile {input.scorefile} \
                --bfile {params.bfile} \
                --pheno {params.pheno} \
                --extract results/classical/thin/thin$p.in \
                --power 0 \
                --max-threads {threads}

            awk < {input.pvalue} -v p=$p '($2<p){{print $1}}' > results/classical/just/just$p.in

            ./ldak --calc-scores results/classical/just/just$p \
                --bfile {params.bfile} \
                --pheno {params.pheno} \
                --extract results/classical/just/just$p.in \
                --power 0 \
                --scorefile {input.scorefile} \
                --max-threads {threads}

        done

        grep Score_1 {{results/classical/just/just,results/classical/thin/thin}}{{5e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,0.1,1}}.cors \
            | awk '{{print $2}}' > {output.results}
        """