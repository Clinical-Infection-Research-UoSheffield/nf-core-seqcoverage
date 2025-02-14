process GENERATE_COVERAGE {
    tag "$meta.id"
    label 'process_low'

    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'docker://staphb/samtools:1.21' :
        'staphb/samtools:1.21' }"

    input:
    tuple val(meta), path(aligned_bam), path(bam_index), val(virus)

    output:
    tuple val(meta), path('*_coverage.txt')                           , optional: true, emit: coverage
    path  "versions.yml"                                              , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def accession = virus.accession
    def prefix = task.ext.prefix ?: "${meta.id}_${virus.name}"
    """
    # Run samtools view and sort
    samtools view -b $aligned_bam ${accession} | samtools sort -o ${prefix}_aligned.bam

    # Check coverage output and redirect to file only if non-empty
    samtools coverage -m ${prefix}_aligned.bam | grep -q . && samtools coverage -m ${prefix}_aligned.bam > ${prefix}_coverage.txt || echo "No coverage data found, no file created."


    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        samtools: \$(echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//')
    END_VERSIONS

    """

    stub:
    def prefix = task.ext.prefix ?: "${meta.id}_${virus.name}"
    """
    touch ${prefix}_aligned.bam
    touch ${prefix}_coverage.txt

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        samtools: \$(echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//')
    END_VERSIONS
    """
}
