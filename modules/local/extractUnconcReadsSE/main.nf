// 5.4. Extract singly or discordantly aligned reads from Bowtie2 output
process EXTRACT_UNCONC_READS {
    label "seqtk"
    label "single"
    input:
        tuple val(sample), path(reads), path(id_file)
    output:
        tuple val(sample), path("${sample}_bowtie2_mapped_unconc.fastq.gz")
    shell:
        '''
        inp0="!{id_file}"
        inp1="!{reads[0]}"
        outp1="!{sample}_bowtie2_mapped_unconc.fastq.gz"
        seqtk subseq ${inp1} ${inp0} | gzip > ${outp1}
        '''
}
