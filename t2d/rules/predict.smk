
rule predict_prs:
    input:
        scorefile = "results/megaprs/{model}/{model}.effects",
        bed = "data/bed/{chrom}.bed"
    output:
        cors = "results/megaprs/{model}/{chrom}/score.cors"
    params:
        bfile = "data/bed/{chrom}",
        power = 0,
        phenofile = "data/t1d.pheno"
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