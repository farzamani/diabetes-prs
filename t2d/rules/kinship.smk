rule calc_thin:
    input:
        rsids = "data/sumstats/rsids.list"
    output:
        thin_in = "data/target/qc/chr6.in"
    params:
        prefix = "data/target/qc/chr6",
        bfile = "data/geno_plink/chr6",
        prune = 0.1, # correlation squared threshold
        window_kb = 1000
    threads:
        4
    resources:
        mem_mb = get_mem_mb,
        runtime = 720
    shell:
        """
        ./ldak --thin {params.prefix} \
            --bfile {params.bfile} \
            --window-prune {params.prune} \
            --window-kb {params.window_kb} \
            --extract {input.rsids}
        """
