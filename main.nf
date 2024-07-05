include { RUN } from "./workflows/run"
include { INDEX } from "./workflows/index"
include { SINGLE } from "./workflows/single"

// Configure working and output directories
pubDir  = "${params.base_dir}/output"

workflow {
    if (params.mode == "index") {
        INDEX()
    } else if (params.mode == "run") {
        RUN()
    } else if (params.mode == "single") {
        SINGLE()
    }
}

output {
    directory "${pubDir}"
    mode "copy"
}
