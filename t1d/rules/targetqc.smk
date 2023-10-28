rule targetqc_nodup:
    input:
        "data/geno_plink/chr6.pvar"
    output:
        "data/target/chr6.nodup.snplist"
    threads:
        4
    resources:
        mem_mb = get_mem_mb,
        runtime = 720
    shell:
        """
        cat {input} | awk '{{if(seen[$3]==1) {{print $3 > "{output}"}} seen[$3]++}}'
        """

rule targetqc_standard:
    input:
        pvar = "data/geno_plink/chr6.pvar",
        pgen = "data/geno_plink/chr6.pgen",
        psam = "data/geno_plink/chr6.psam",
        nodup = rules.targetqc_nodup.output
    output:
        fam = "data/target/chr6.qc.fam",
        snplist = "data/target/chr6.qc.snplist",
        mindrem = "data/target/chr6.qc.mindrem.id"
    params:
        maf = 0.01,
        hwe = 1e-6,
        geno = 0.01,
        mind = 0.01,
        out = "data/target/chr6.qc"
    threads:
        4
    resources:
        mem_mb = get_mem_mb,
        runtime = 720
    shell:
        """
        plink2 \
            --pvar {input.pvar} \
            --pgen {input.pgen} \
            --psam {input.psam} \
            --maf {params.maf} \
            --hwe {params.hwe} \
            --geno {params.geno} \
            --mind {params.mind} \
            --write-snplist allow-dups \
            --make-just-fam \
            --exclude {input.nodup} \
            --out {params.out}
        """

rule targetqc_remove_highcorr:
    input:
        pvar = "data/geno_plink/chr6.pvar",
        pgen = "data/geno_plink/chr6.pgen",
        psam = "data/geno_plink/chr6.psam",
        snplist = rules.targetqc_standard.output.snplist,
        fam = rules.targetqc_standard.output.fam
    output:
        prune = "data/target/chr6.corr.prune.in"
    params:
        window_size = "1000kb",
        r2 = 0.5,
        out = "data/target/chr6.corr"
    threads:
        4
    resources:
        mem_mb = get_mem_mb,
        runtime = 720
    shell:
        """
        plink2 \
            --pvar {input.pvar} \
            --pgen {input.pgen} \
            --psam {input.psam} \
            --keep {input.fam} \
            --extract {input.snplist} \
            --indep-pairwise {params.window_size} {params.r2} \
            --out {params.out}
        """

rule targetqc_heterozigosity_rate:
    input:
        pvar = "data/geno_plink/chr6.pvar",
        pgen = "data/geno_plink/chr6.pgen",
        psam = "data/geno_plink/chr6.psam",
        prune = rules.targetqc_remove_highcorr.output.prune,
        fam = rules.targetqc_standard.output.fam
    output:
        het = "data/target/chr6.het.het"
    params:
        out = "data/target/chr6.het"
    threads:
        6
    resources:
        mem_mb = get_mem_mb,
        runtime = 720
    shell:
        """
        plink2 \
            --pvar {input.pvar} \
            --pgen {input.pgen} \
            --psam {input.psam} \
            --extract {input.prune} \
            --keep {input.fam} \
            --het \
            --out {params.out}
        """

rule targetqc_heterozigosity_rate_out:
    input:
        het = rules.targetqc_heterozigosity_rate.output.het
    output:
        valid = "data/target/chr6.het.valid"
    threads:
        4
    resources:
        mem_mb = get_mem_mb,
        runtime = 720
    script:
        os.path.join(workflow.basedir, "scripts/targetqc/compute_het.R")

rule targetqc_check_sex:
    input:
        pvar = "data/geno_plink/chrX.pvar",
        pgen = "data/geno_plink/chrX.pgen",
        psam = "data/geno_plink/chrX.psam",
        prune = rules.targetqc_remove_highcorr.output.prune
    output:
        sex = "data/target/chrX.sex.sexcheck",
        bed = temp("data/temp/chrX.bed"),
        bim = temp("data/temp/chrX.bim"),
        fam = temp("data/temp/chrX.fam")
    params:
        out = "data/target/chrX.sex",
        bfile = "data/temp/chrX"
    threads:
        4
    resources:
        mem_mb = get_mem_mb,
        runtime = 720
    shell:
        """
        plink2 \
            --pvar {input.pvar} \
            --pgen {input.pgen} \
            --psam {input.psam} \
            --extract {input.prune} \
            --make-bed \
            --out {params.bfile}

        plink \
            --bed {output.bed} \
            --bim {output.bim} \
            --fam {output.fam} \
            --check-sex \
            --out {params.out}
        """

rule targetqc_check_sex_out:
    input:
        het = rules.targetqc_heterozigosity_rate_out.output,
        sex = rules.targetqc_check_sex.output
    output:
        valid = "data/target/chr6.qc.valid"
    threads:
        4
    resources:
        mem_mb = get_mem_mb,
        runtime = 720
    script:
        os.path.join(workflow.basedir, "scripts/targetqc/check_sex.R")

rule targetqc_relatedness_check:
    input:
        pvar = "data/geno_plink/chr6.pvar",
        pgen = "data/geno_plink/chr6.pgen",
        psam = "data/geno_plink/chr6.psam",
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
        mem_mb = get_mem_high,
        runtime = 720
    shell:
        """
        plink2 \
            --pvar {input.pvar} \
            --pgen {input.pgen} \
            --psam {input.psam} \
            --extract {input.prune} \
            --keep {input.val} \
            --king-cutoff {params.cutoff} \
            --out {params.out}
        """

rule targetqc_make_bed:
    input:
        pvar = "data/geno_plink/chr6.pvar",
        pgen = "data/geno_plink/chr6.pgen",
        psam = "data/geno_plink/chr6.psam",
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
        mem_mb = get_mem_mb,
        runtime = 720
    shell:
        """
        plink2 \
            --pvar {input.pvar} \
            --pgen {input.pgen} \
            --psam {input.psam} \
            --make-bed \
            --keep {input.rel} \
            --extract {input.snplist} \
            --out {params.out}
        """
