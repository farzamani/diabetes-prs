rule targetqc_dup:
    input:
        pvar = "data/geno_plink/{chrom}.pvar"
    output:
        dup = "data/target/qc/{chrom}.dup.snplist"
    threads:
        4
    resources:
        mem_mb = get_mem_mb,
        runtime = 720
    shell:
        """
        cat {input.pvar} | awk '{{if(seen[$3]==1) {{print $3 > "{output.dup}"}} seen[$3]++}}'
        """

rule make_bfile:
    input:
        pvar = "data/geno_plink/{chrom}.pvar",
        pgen = "data/geno_plink/{chrom}.pgen",
        psam = "data/geno_plink/{chrom}.psam",
        dup = "data/target/qc/{chrom}.dup.snplist"
    output:
        bed = "data/geno_plink/{chrom}.bed",
        bim = "data/geno_plink/{chrom}.bim",
        fam = "data/geno_plink/{chrom}.fam",
    params:
        bfile = "data/geno_plink/{chrom}"
    threads:
        8
    resources:
        mem_mb = get_mem_high,
        runtime = 720
    shell:
        """
        plink2 \
            --pvar {input.pvar} \
            --pgen {input.pgen} \
            --psam {input.psam} \
            --make-bed \
            --out {params.bfile} \
            --exclude {input.dup}
        """
