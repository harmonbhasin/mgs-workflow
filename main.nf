include { RUN } from "./workflows/run"
include { INDEX } from "./workflows/index"
include { TEST } from "./workflows/test"

// Configure working and output directories
pubDir  = "${params.base_dir}/output"

workflow {
    if (params.mode == "index") {
        INDEX()
    } else if (params.mode == "run") {
        RUN()
    } else if (params.mode == "test") {
        TEST()
    }
}

output {
    directory "${pubDir}"
    mode "copy"
}
