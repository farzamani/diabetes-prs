rule predict_prs:
    input:
        "results/megaprs/{model}/{model}.effects"
    output:
        "results/megaprs/{model}/score"
    params:
        bfile = "data/bed/chr6",
        power = 0
    shell:
        """
        ./ldak --calc-scores results/megaprs/{wildcards.model}/score \
            --scorefile {input} \
            --bfile {params.bfile} \
            --pheno data/t1d.pheno \
            --power {params.power}
        """
