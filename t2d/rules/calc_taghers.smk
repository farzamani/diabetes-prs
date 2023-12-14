rule calc_tagging:
    input:
        snplist = rules.valid_snps.output.valid
    output:
        tagging = "results/tagging/1000G.404EUR.tagging",
        matrix = "results/tagging/1000G.404EUR.matrix"
    params:
        bfile = "data/reference/1000G.404EUR",
        tag_out = "results/tagging/1000G.404EUR",
        power = -1,
        window_kb = 1000
    threads:
        8
    resources:
        mem_mb = get_mem_high,
        runtime = 720
    shell:
        """
        ./ldak --calc-tagging {params.tag_out} \
            --bfile {params.bfile} \
            --save-matrix YES \
            --power {params.power} \
            --window-kb {params.window_kb} \
            --extract {input.snplist} \
            --ignore-weights YES \
            --max-threads {threads}
        """

rule calc_sumher:
    input:
        sumstats = "data/sumstats/sumstats.txt",
        matrix = "results/tagging/1000G.404EUR.matrix",
        tagging = "results/tagging/1000G.404EUR.tagging",
        snplist = rules.valid_snps.output.valid
    output:
        indhers = "results/snphers/sumher.ind.hers"
    params:
        sumher_out = "results/snphers/sumher",
        power = -1,
        window_kb = 1000,
    threads:
        8
    resources:
        mem_mb = get_mem_high,
        runtime = 720
    shell:
        """        
        ./ldak --sum-hers {params.sumher_out} \
            --tagfile {input.tagging} \
            --summary {input.sumstats} \
            --matrix {input.matrix} \
            --extract {input.snplist} \
            --max-threads {threads} \
            --check-sums NO
        """