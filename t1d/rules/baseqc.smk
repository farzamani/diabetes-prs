"""
Quality Control for Base Data (Reference Panel)
1. Removes duplicate SNPs
2. Removes SNPs with low MAF
3. Removes ambiguous SNPs
"""

rule baseqc_remove_duplicate:
    input:
        sumstats = "data/preprocessed/sumstats.txt.gz"
    output:
        sumstats = temp("data/preprocessed/sumstats.nodup")
    threads:
        4
    resources:
        mem_mb = get_mem_high,
        runtime = 720
    shell:
        """
        # SNPs duplicate check
        echo "Removing duplicate SNPs..."
        zcat {input.sumstats} | \
            awk '{{seen[$1]++; if(seen[$1]==1) {{print}}}}' > {output.sumstats}
        echo "Removing duplicate SNPs... Done"
        """

rule baseqc_remove_low_maf:
    input:
        sumstats = "data/preprocessed/sumstats.nodup"
    output:
        sumstats = temp("data/preprocessed/sumstats.maf")
    params:
        maf = 0.01
    threads:
        4
    resources:
        mem_mb = get_mem_high,
        runtime = 720
    shell:
        """
        # Removing low MAF
        echo "Removing low MAF..."
        cat {input.sumstats} | \
            awk 'NR==1 || ($6 > {params.maf}) {{print}}' > {output.sumstats}
        echo "Removing low MAF... Done"
        """

rule baseqc_remove_ambiguous:
    input:
        sumstats = "data/preprocessed/sumstats.maf"
    output:
        sumstats = "data/sumstats/sumstats.txt"
    threads:
        4
    resources:
        mem_mb = get_mem_high,
        runtime = 720
    shell:
        """
        # Removing ambiguous SNPs
        echo "Removing ambiguous SNPs..."
        cat {input.sumstats} | \
            awk 'NR==1 || length($2) == 1 && length($3) == 1 && \
                !( ($2=="A" && $3=="T") || \
                ($2=="T" && $3=="A") || \
                ($2=="G" && $3=="C") || \
                ($2=="C" && $3=="G")) {{print}}' > {output.sumstats}
        echo "Removing ambiguous SNPs... Done"
        """

rule baseqc_summary:
    input:
        raw = "data/preprocessed/sumstats.txt.gz",
        nodup = "data/preprocessed/sumstats.nodup",
        maf = "data/preprocessed/sumstats.maf",
        sumstats = "data/sumstats/sumstats.txt"
    output:
        snps = "data/sumstats/snps.list"
        # rsids = "data/sumstats/rsids.list"
    threads:
        4
    resources:
        mem_mb = get_mem_high,
        runtime = 720
    log:
        "data/sumstats/baseqc.log"
    shell:
        """
        # Print number of SNPs
        echo "Number of SNPs in raw data:" > {log}
        zcat {input.raw} | wc -l >> {log}

        echo "SNPs left after removing duplicate:" >> {log}
        cat {input.nodup} | wc -l >> {log}

        echo "SNPs left after removing low MAF:" >> {log}
        cat {input.maf} | wc -l >> {log}

        echo "SNPs left after removing ambiguous SNPs:" >> {log}
        cat {input.sumstats} | wc -l >> {log}

        echo "Extracting SNPs..." >> {log}
        awk < {input.sumstats} 'NR>1 {{print $1}}' \
            > {output.snps}

        echo "Summary statistics quality control completed!" >> {log}
        """
