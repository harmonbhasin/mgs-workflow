// Combine concordantly and non-concordantly mapped read pairs
process COMBINE_MAPPED_BOWTIE2_READS {
    label "BBTools"
    label "single"
    input:
        tuple val(sample), path(reads_conc), path(reads_mapped_unconc)
    output:
        tuple val(sample), path("${sample}_bowtie2_mapped_all.fastq.gz")
    shell:
        '''
        inc1=!{reads_conc[0]}
        inu1=!{reads_mapped_unconc[0]}
        out1=!{sample}_bowtie2_mapped_all.fastq.gz
        cat $inc1 $inu1 > $out1
        '''
}
