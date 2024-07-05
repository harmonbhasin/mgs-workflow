process FASTP {
    label "large"
    label "fastp"
    input:
        tuple val(sample), path(reads)
        path(adapters)
    output:
        tuple val(sample), path("${sample}_fastp.fastq.gz"), emit: reads
        tuple val(sample), path("${sample}_fastp_failed.fastq.gz"), emit: failed
        tuple val(sample), path("${sample}_fastp.{json,html}"), emit: log
    shell:
        '''
        # Define paths and subcommands
        o1=!{sample}_fastp.fastq.gz
        of=!{sample}_fastp_failed.fastq.gz
        oj=!{sample}_fastp.json
        oh=!{sample}_fastp.html
        ad=!{adapters}
        io="--in1 !{reads[0]} --out1 ${o1} --failed_out ${of} --html ${oh} --json ${oj} --adapter_fasta ${ad}"
        par="--cut_front --cut_tail --trim_poly_x --cut_mean_quality 25 --average_qual 25 --qualified_quality_phred 20 --verbose --dont_eval_duplication --thread !{task.cpus} --low_complexity_filter"
        # Execute
        fastp ${io} ${par}
        '''
}
