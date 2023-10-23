rule mega_prs:
    input:
        sumstats = "data/sumstats/sumstats.txt",
        indhers = "results/snphers/sumher.ind.hers",
        snplist = rules.baseqc_summary.output
    output:
        "results/megaprs/{model}/{model}.effects"
    params:
        cors = "results/cors/cors",
        cv = 0.1
    threads:
        8
    resources:
        mem_mb = 32000,
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
            --window-kb 1000 \
            --allow-ambiguous YES \
            --extract {input.snplist} \
            --max-threads {threads}
        """

rule predict_prs:
    input:
        "results/megaprs/{model}/{model}.effects"
    output:
        "results/megaprs/{model}/score.cors"
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
