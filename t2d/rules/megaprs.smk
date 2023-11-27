rule high_ld:
    input:
        highld = "data/highld/highld.txt"
    output:
        highld = "results/highld/genes.predictors.used"
    params:
        bfile = "data/reference/1000G.404EUR",
        outdir = "results/highld"
    threads:
        1
    resources:
        mem_mb = get_mem_mb,
        runtime = 720
    shell:
        """
        ./ldak --cut-genes {params.outdir} \
            --bfile {params.bfile} \
            --genefile {input.highld}
        """

rule mega_prs:
    input:
        sumstats = "data/sumstats/sumstats.txt",
        indhers = "results/snphers/sumher.ind.hers",
        snplist = rules.valid_snps.output.valid,
        cors = "results/cors/cors.cors.bim",
        highld = rules.high_ld.output.highld,
        pheno = "data/t2d.pheno"
    output:
        "results/megaprs/{model}/{model}.effects"
    params:
        cors = "results/cors/cors",
        cv = 0.2,
        window_kb = 1000
    threads:
        8
    resources:
        mem_mb = get_mem_high,
        runtime = 720
    shell:
        """
        ./ldak --mega-prs results/megaprs/{wildcards.model}/{wildcards.model} \
            --model {wildcards.model} \
            --summary {input.sumstats} \
            --ind-hers {input.indhers} \
            --cors {params.cors} \
            --high-LD {input.highld} \
            --cv-proportion {params.cv} \
            --window-kb {params.window_kb} \
            --extract {input.snplist} \
            --max-threads {threads} \
            --pheno {input.pheno}  
        """