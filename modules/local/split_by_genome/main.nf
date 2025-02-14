process SPLIT_BY_GENOME {
    tag "$meta.id"
    label 'process_low'

    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/grep:3.4--hf43ccf4_4' :
        'biocontainers/grep:3.4--hf43ccf4_4' }"

    input:
    tuple val(meta), path(classified_reads), val(virus)

    output:
    tuple env(new_meta), path('*_classified_reads.fastq')                            , emit: subsets
    path  "versions.yml"                                                             , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def new_meta = meta.clone()
    new_meta['taxid'] = virus.taxid    // Add taxid key
    new_meta['virus'] = virus.name     // Add virus name key
    new_meta['accession'] = virus.accession // Add accession key
    def prefix = task.ext.prefix ?: "${meta.id}_${new_meta.virus}"
    """
    zcat ${classified_reads} | grep "kraken:taxid|${virus.taxid}" -A3 --no-group-separator > ${prefix}_classified_reads.fastq || true

    cat <<-END_VERSIONS > versions.yml
        grep: \$(grep --version | head -n1 | cut -f 4 -d ' ')
    END_VERSIONS

    """

    stub:
    def prefix = task.ext.prefix ?: "${meta.id}_${new_meta.virus}"
    """
    touch ${prefix}_classified_reads.fastq

    cat <<-END_VERSIONS > versions.yml
        grep: \$(grep --version | head -n1 | cut -f 4 -d ' ')
    END_VERSIONS
    """
}
