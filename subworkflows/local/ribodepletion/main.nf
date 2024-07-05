/***************************
| MODULES AND SUBWORKFLOWS |
***************************/

include { QC } from "../../../subworkflows/local/qc" addParams(fastqc_cpus: params.fastqc_cpus, fastqc_mem: params.fastqc_mem)
include { BBDUK } from "../../../modules/local/bbdukSE" addParams(suffix: params.bbduk_suffix)

/***********
| WORKFLOW |
***********/

workflow RIBODEPLETION {
    take:
        reads_ch
        ref_dir
    main:
        ribo_path = "${ref_dir}/results/ribo-ref-concat.fasta.gz"
        bbduk_ch = BBDUK(reads_ch, ribo_path, params.min_kmer_fraction, params.k)
        qc_ch = QC(bbduk_ch.reads, params.stage_label)
    emit:
        reads = bbduk_ch.reads
        ribo = bbduk_ch.fail
        qc = qc_ch.qc
}
