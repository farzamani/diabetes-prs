rule predict_prs_compare:
    input:
        scorefile = "results/megaprs/{model}/{model}.effects",
        snplist = rules.valid_snps.output.valid
    output:
        cors = "results/compare/{model}/score.cors",
        profile = "results/compare/{model}/score.profile"
    params:
        bfile = "data/target/geno2",
        power = 0,
        phenofile = "data/t1d.pheno"
    threads:
        16
    resources:
        mem_mb = get_mem_high,
        runtime = 720
    shell:
        """
        ./ldak --calc-scores results/compare/{wildcards.model}/score \
            --scorefile {input.scorefile} \
            --bfile {params.bfile} \
            --pheno {params.phenofile} \
            --power {params.power} \
            --max-threads {threads}
        """

rule jackknife_compare:
    input:
        profile = rules.predict_prs_compare.output.profile
    output:
        jackknife = "results/compare/{model}/jackknife.jack"
    params:
        prevalence = 0.0238
    threads:
        8
    resources:
        mem_mb = get_mem_high,
        runtime = 720
    shell:
        """
        ./ldak --jackknife results/compare/{wildcards.model}/jackknife \
            --profile results/compare/{wildcards.model}/score.profile \
            --num-blocks 200 \
            --AUC YES \
            --prevalence {params.prevalence}
        """