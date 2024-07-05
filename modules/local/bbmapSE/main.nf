// Run BBMap and return mapped and unmapped reads
process BBMAP {
    label "max"
    label "BBTools"
    input:
        tuple val(sample), path(reads)
        path(index_dir)
    output:
        tuple val(sample), path("${sample}_${params.suffix}_bbmap_mapped.fastq.gz"), emit: reads_mapped
        tuple val(sample), path("${sample}_${params.suffix}_bbmap_unmapped.fastq.gz"), emit: reads_unmapped
        tuple val(sample), path("${sample}_${params.suffix}_bbmap.stats.txt"), emit: stats
    shell:
        '''
        # Define input/output
        in1=!{reads[0]}
        ou1=!{sample}_!{params.suffix}_bbmap_unmapped.fastq.gz
        om1=!{sample}_!{params.suffix}_bbmap_mapped.fastq.gz
        stats=!{sample}_!{params.suffix}_bbmap.stats.txt
        io="in=${in1} outu=${ou1} outm=${om1} statsfile=${stats} path=!{index_dir}"
        # Define parameters
        par="minid=0.8 maxindel=4 bwr=0.25 bw=25 quickmatch minhits=2 t=!{task.cpus} -Xmx60g"
        # Execute
        bbmap.sh ${io} ${par}
        '''
}

// Generate a BBMap index from an input file
process BBMAP_INDEX {
    label "BBTools"
    label "max"
    input:
        path(reference_fasta)
    output:
        path("${params.outdir}")
    shell:
        '''
        odir="!{params.outdir}"
        mkdir ${odir}
        cp !{reference_fasta} ${odir}/reference.fasta.gz
        cd ${odir}
        bbmap.sh ref=reference.fasta.gz t=!{task.cpus} -Xmx60g
        #tar -czf human-ref-index.tar.gz human_ref_index
        '''
}
