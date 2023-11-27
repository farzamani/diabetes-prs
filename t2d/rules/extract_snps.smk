
rule valid_snps:
    input:
        sumstats = "data/sumstats/sumstats.txt",
        ref = "data/reference/1000G.404EUR.bim",
        cors = "results/cors/cors.cors.bim"
    output:
        sumstats = "results/snps/snps.sumstats",
        ref = "results/snps/snps.ref",
        intersection = "results/snps/snps.intersection",
        cors = "results/snps/snps.cors",
        valid = "results/snps/snps.valid"
    log:
        "results/snps/snps.log"
    resources:
        mem_mb = get_mem_mb,
        runtime = 720
    shell:
        """
        cat {input.sumstats} | awk 'NR>1 {{print $1,$2,$3}}' > {output.sumstats}
        cat {input.ref} | awk '{{print $2,$5,$6}}' > {output.ref}
        cat {input.cors} | awk '{{print $2,$5,$6}}' > {output.cors}
        
        awk 'NR==FNR {{a[$1 $2 $3]; next}} ($1 $2 $3 in a)' {output.sumstats} {output.ref} > {output.intersection}
        # grep -Fxf {output.sumstats} {output.ref} > {output.intersection}
        
        awk 'NR==FNR {{a[$1 $2 $3]; next}} ($1 $2 $3 in a)' {output.intersection} {output.cors} > {output.valid}

        echo "Number of SNPs in sumstats, reference, and cors:" >> {log}
        wc -l {output.sumstats} >> {log}
        wc -l {output.ref} >> {log}

        echo "Number of SNPs in both sumstats and reference:" > {log}
        wc -l {output.intersection} >> {log}

        wc -l {output.cors} >> {log}

        echo "Finding SNPs in both intersection and cors..." >> {log}
        echo "Number of SNPs used in the pipeline:" >> {log}
        wc -l {output.valid} >> {log}
        """