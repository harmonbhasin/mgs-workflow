// Detection and removal of contaminant reads
process BBDUK {
    label "large"
    label "BBTools"
    input:
        tuple val(sample), path(reads)
        path(contaminant_ref)
        val(min_kmer_fraction)
        val(k)
    output:
        tuple val(sample), path("${sample}_${params.suffix}_bbduk_pass.fastq.gz"), emit: reads
        tuple val(sample), path("${sample}_${params.suffix}_bbduk_fail.fastq.gz"), emit: fail
        tuple val(sample), path("${sample}_${params.suffix}_bbduk.stats.txt"), emit: log
    shell:
        '''
        # Define input/output
        in1=!{reads[0]}
        op1=!{sample}_!{params.suffix}_bbduk_pass.fastq.gz
        of1=!{sample}_!{params.suffix}_bbduk_fail.fastq.gz
        stats=!{sample}_!{params.suffix}_bbduk.stats.txt
        ref=!{contaminant_ref}
        io="in=${in1} ref=${ref} out=${op1} outm=${of1} stats=${stats}"
        # Define parameters
        par="minkmerfraction=!{min_kmer_fraction} k=!{k} t=!{task.cpus} -Xmx30g"
        # Execute
        bbduk.sh ${io} ${par}
        '''
}
