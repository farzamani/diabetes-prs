rule valid_snps:
    input:
        sumstats = "data/sumstats/sumstats.txt",
        ref = "data/reference/1000G.404EUR.bim",
        geno = "data/target/geno2.bim" # dsmwpred/data/ukbb
    output:
        sumstats = "results/snps/snps.sumstats",
        ref = "results/snps/snps.ref",
        intersection = "results/snps/snps.intersection",
        geno = "results/snps/snps.geno",
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
        cat {input.geno} | awk '{{print $2,$5,$6}}' > {output.geno}

        awk 'NR==FNR {{a[$1 $2 $3]; next}} ($1 $2 $3 in a)' {output.sumstats} {output.ref} > {output.intersection}

        awk 'NR==FNR {{a[$1 $2 $3]; next}} ($1 $2 $3 in a)' {output.intersection} {output.geno} > {output.valid}

        echo "Number of SNPs in sumstats, reference, and geno:" >> {log}
        wc -l {output.sumstats} >> {log}
        wc -l {output.ref} >> {log}

        echo "Number of SNPs in both sumstats and reference:" > {log}
        wc -l {output.intersection} >> {log}

        wc -l {output.geno} >> {log}

        echo "Finding SNPs in both intersection and geno..." >> {log}
        echo "Number of SNPs used in the pipeline:" >> {log}
        wc -l {output.valid} >> {log}
        """