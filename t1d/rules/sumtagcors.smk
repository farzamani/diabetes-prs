rule calc_tagging:
    input:
        snplist = rules.baseqc_summary.output.snps
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
            --ignore-weights YES \
            --save-matrix YES \
            --power {params.power} \
            --window-kb {params.window_kb} \
            --extract {input.snplist} \
            --max-threads {threads}
        """

rule calc_sumher:
    input:
        sumstats = "data/sumstats/sumstats.txt",
        matrix = "results/tagging/1000G.404EUR.matrix",
        tagging = "results/tagging/1000G.404EUR.tagging",
        snplist = rules.baseqc_summary.output.snps
    output:
        indhers = "results/snphers/sumher.ind.hers"
    params:
        sumher_out = "results/snphers/sumher",
        power = -1,
        window_kb = 1000,
        cutoff = 0.01 # remove predictors that explain more than 1% of phenotypic variance
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
            --cutoff {params.cutoff} \
            --max-threads {threads} \
            --check-sums NO
        """

rule calc_cors:
    input:
        snplist = rules.baseqc_summary.output.snps
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

rule consistent_snps:
    input:
        cors = "results/cors/cors.cors.bim",
        sumstats = "data/sumstats/sumstats.txt"
    output:
        cors = temp("data/temp/snps.cors"),
        sumstats = temp("data/temp/snps.sumstats"),
        valid = "data/snps/snps.valid"
    log:
        "data/snps/snps.log"
    threads:
        1
    resources:
        mem_mb = get_mem_mb,
        runtime = 720
    shell:
        """
        cat {input.sumstats} | awk 'NR>1 {{print $1,$2,$3}}' > {output.sumstats}
        cat {input.cors} | awk '{{print $2,$5,$6}}' > {output.cors}
        
        awk 'NR==FNR {{a[$1 $2 $3]; next}} ($1 $2 $3 in a)' {input.sumstats} {input.cors} > {output.valid}

        wc -l {output.sumstats} > {log}
        wc -l {output.cors} >> {log}
        wc -l {output.valid} >> {log}
        """