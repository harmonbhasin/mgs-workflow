// Concatenate split files from same sample together
process CONCAT_GZIPPED {
    label "single"
    label "seqtk"
    input:
        path(raw_files_directory)
        tuple val(sample), val(libraries)
    output:
        tuple val(sample), path("${sample}.fastq.gz"), emit: reads
    shell:
        '''
        # Preamble
        read_dir=!{raw_files_directory}
        echo Raw files directory: $read_dir
        echo Sample: !{sample}
        echo Libraries: !{libraries.join(" ")}
        # Get file paths from library IDs
        r1=""
        for l in !{libraries.join(" ")}; do
            L1=$(ls ${read_dir}/*${l}*.fastq.gz)
            r1="${r1} ${L1}"
            done
        ln1=$(wc -w <<< ${r1})
        echo Forward read files: ${ln1}
        if [[ ${ln1} == 0 ]]; then
            >&2 echo "Error: No read files specified"
        fi
        # Concatenate or copy
        out1=!{sample}.fastq.gz
        echo Read 1 files to concatenate: ${r1}
        if [[ ${ln1} == 1 ]]; then
            # Make copies
            echo "Only one file per read pair; copying."
            cp ${r1} ${out1}
            # Test copies and fail if not identical
            cmp ${r1} ${out1} > diff1.txt
            if [[ -s diff1.txt ]]; then
                >&2 echo "Error: $(cat diff1)"
                echo "Input file lengths: $(zcat ${r1} | wc -l) $(zcat ${r2} | wc -l)
                echo "Output file lengths: $(zcat ${out1} | wc -l) $(zcat ${out2} | wc -l)
                exit 1
            fi
        else
            # Concatenate
            # TODO: Add error checking and handling
            cat ${r1} > ${out1}
        fi
        '''
}
