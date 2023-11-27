"""
Quality Control for Target Data
    0. SNPs QC (some are performed in baseqc)
        - Removes duplicated SNPs
        - Removes inconsistent SNPs
        - 
    1. Standard QC
        - Removes all SNPs with minor allele frequency (MAF)
        - Removes SNPs with low P-value from the Hardy-Weinberg Equilibrium
        - Removes SNPs that are missing in a high fraction of subjects
        - Removes individuals who have a high rate of genotype missingness
        Outputs:
            - List of valid SNPs
            - List of valid individuals
    2. Removes highly correlated SNPs
    3. Removes individuals with extreme heterozigosity rates (very high and very low)
"""

rule standardqc:
    input:
        bed = "data/target/geno2.bed",
        bim = "data/target/geno2.bim",
        fam = "data/target/geno2.fam"
    output:
        fam = "data/target/geno2.qc.fam",
        snplist = "data/target/geno2.qc.snplist",
        mindrem = "data/target/geno2.qc.mindrem.id"
    params:
        maf = 0.01,
        hwe = 1e-6,
        geno = 0.01,
        mind = 0.01,
        out = "data/target/geno2.qc"
    threads:
        8
    resources:
        mem_mb = get_mem_high,
        runtime = 720
    shell:
        """
        plink2 \
            --bed {input.bed} \
            --bim {input.bim} \
            --fam {input.fam} \
            --maf {params.maf} \
            --hwe {params.hwe} \
            --geno {params.geno} \
            --mind {params.mind} \
            --write-snplist \
            --make-just-fam \
            --out {params.out} \
            --threads {threads}
        """

rule remove_highcorr_snps:
    input:
        bed = "data/target/geno2.bed",
        bim = "data/target/geno2.bim",
        fam = "data/target/geno2.fam"
        snplist = rules.standardqc.output.snplist,
        fam = rules.standardqc.output.fam
    output:
        prune = "data/target/qc/{chrom}.corr.prune.in"
    params:
        window_size = "1000kb",
        r2 = 0.05,
        out = "data/target/qc/{chrom}.corr"
    threads:
        4
    resources:
        mem_mb = get_mem_high,
        runtime = 720
    shell:
        """
        plink2 \
            --bed {input.bed} \
            --bim {input.bim} \
            --fam {input.fam} \
            --keep {input.fam} \
            --extract {input.snplist} \
            --indep-pairwise {params.window_size} {params.r2} \
            --out {params.out}
        """

rule targetqc_heterozigosity_rate:
    input:
        bed = "data/target/geno2.bed",
        bim = "data/target/geno2.bim",
        fam = "data/target/geno2.fam"
        prune = rules.targetqc_remove_highcorr.output.prune,
        fam = rules.targetqc_standard.output.fam
    output:
        het = "data/target/chr6.het.het"
    params:
        out = "data/target/chr6.het"
    threads:
        6
    resources:
        mem_mb = get_mem_high,
        runtime = 720
    shell:
        """
        plink2 \
            --bed {input.bed} \
            --bim {input.bim} \
            --fam {input.fam} \
            --extract {input.prune} \
            --keep {input.fam} \
            --het \
            --out {params.out}
        """


rule targetqc_heterozigosity_rate_out:
    input:
        het = rules.targetqc_heterozigosity_rate.output.het
    output:
        valid = "data/target/qc/geno2.het.valid.fam"
    threads:
        4
    resources:
        mem_mb = get_mem_high,
        runtime = 720
    script:
        os.path.join(workflow.basedir, "scripts/targetqc/compute_het.R")


rule targetqc_relatedness_check:
    input:
        bed = "data/target/geno2.bed",
        bim = "data/target/geno2.bim",
        fam = "data/target/geno2.fam"
        prune = rules.targetqc_remove_highcorr.output.prune,
        val = rules.targetqc_heterozigosity_rate_out.output
    output:
        "data/target/chr6.rel.rel.id"
    params:
        out = "data/target/chr6.rel",
        cutoff = 0.125
    threads:
        4
    resources:
        mem_mb = 256000,
        runtime = 720
    shell:
        """
        plink2 \
            --bed {input.bed} \
            --bim {input.bim} \
            --fam {input.fam} \
            --extract {input.prune} \
            --keep {input.val} \
            --king-cutoff {params.cutoff} \
            --out {params.out}
        """


rule targetqc_make_bed:
    input:
        bed = "data/target/geno2.bed",
        bim = "data/target/geno2.bim",
        fam = "data/target/geno2.fam"
        rel = rules.targetqc_relatedness_check.output,
        snplist = rules.targetqc_standard.output.snplist
    output:
        bed = "data/bed/chr6.bed",
        bim = "data/bed/chr6.bim",
        fam = "data/bed/chr6.fam"
    params:
        out = "data/bed/chr6"
    threads:
        4
    resources:
        mem_mb = get_mem_high,
        runtime = 720
    shell:
        """
        plink2 \
            --bed {input.bed} \
            --bim {input.bim} \
            --fam {input.fam} \
            --make-bed \
            --keep {input.rel} \
            --extract {input.snplist} \
            --out {params.out}
        """
