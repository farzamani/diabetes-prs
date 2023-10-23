rule misc:
    input:
        sumstats = "data/sumstats/sumstats.txt"
    output:
        tagging = "results/tagging/1000G.404EUR.tagging",
        matrix = "results/tagging/1000G.404EUR.matrix",
        indhers = "results/snphers/sumher.ind.hers",
        cors = "results/cors/cors.cors.bim",
    params:
        bfile = "data/reference/1000G.404EUR",
        tag_out = "results/tagging/1000G.404EUR",
        sumher_out = "results/snphers/sumher",
        cors_out = "results/cors/cors",
        snplist = rules.baseqc_summary.output,
        power = -1,
        window_kb = 1000
    threads:
        8
    resources:
        mem_mb = 48000,
        runtime = 720
    shell:
        """
        ./ldak --calc-tagging {params.tag_out} \
            --bfile {params.bfile} \
            --ignore-weights YES \
            --save-matrix YES \
            --power {params.power} \
            --window-kb {params.window_kb} \
            --max-threads {threads}
        
        ./ldak --sum-hers {params.sumher_out} \
            --tagfile {output.tagging} \
            --summary {input.sumstats} \
            --matrix {output.matrix} \
            --extract {params.snplist} \
            --max-threads {threads}
        
        ./ldak --calc-cors {params.cors_out} \
            --bfile {params.bfile} \
            --window-kb {params.window_kb} \
            --max-threads {threads}
        """