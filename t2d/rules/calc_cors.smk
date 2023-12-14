rule calc_cors:
    input:
        snplist = "results/snps/snps.valid"
    output:
        cors = "results/cors/cors.cors.bim"
    params:
        bfile = "data/reference/1000G.404EUR",
        cors_out = "results/cors/cors",
        window_kb = 3000
    threads:
        8
    resources:
        mem_mb = get_mem_high,
        runtime = 720
    shell:
        """
        ./ldak --calc-cors {params.cors_out} \
            --bfile {params.bfile} \
            --window-kb {params.window_kb} \
            --extract {input.snplist} \
            --max-threads {threads}
        """