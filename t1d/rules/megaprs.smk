rule mega_prs:
    input:
        sumstats = "data/sumstats/sumstats.txt",
        indhers = "results/snphers/sumher.ind.hers",
        snplist = "data/snps/snps.valid",
        cors = "results/cors/cors.cors.bim"
    output:
        "results/megaprs/{model}/{model}.effects"
    params:
        cors = "results/cors/cors",
        cv = 0.1,
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
            --check-high-LD NO \
            --cv-proportion {params.cv} \
            --window-kb {params.window_kb} \
            --extract {input.snplist} \
            --max-threads {threads}
        """