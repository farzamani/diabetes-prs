
rule predict_prs:
    input:
        scorefile = "results/megaprs/{model}/{model}.effects",
        snplist = rules.valid_snps.output.valid
    output:
        cors = "results/megaprs/{model}/score.cors",
        profile = "results/megaprs/{model}/score.profile"
    params:
        bfile = "data/target/geno2",
        power = 0,
        phenofile = "data/t2d.pheno"
    threads:
        8
    resources:
        mem_mb = get_mem_high,
        runtime = 720
    shell:
        """
        ./ldak --calc-scores results/megaprs/{wildcards.model}/score \
            --scorefile {input.scorefile} \
            --bfile {params.bfile} \
            --pheno {params.phenofile} \
            --power {params.power} \
            --max-threads {threads}
        """

rule jackknife:
    input:
        profile = rules.predict_prs.output.profile
    output:
        jackknife = "results/megaprs/{model}/jackknife.jack"
    params:
        prevalence = 0.1025
    threads:
        4
    resources:
        mem_mb = get_mem_high,
        runtime = 720
    shell:
        """
        ./ldak --jackknife results/megaprs/{wildcards.model}/jackknife \
            --profile results/megaprs/{wildcards.model}/score.profile \
            --num-blocks 200 \
            --AUC YES \
            --prevalence {params.prevalence}
        """