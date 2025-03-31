<h1>
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="docs/images/nf-core-seqcoverage_logo_dark.png">
    <img alt="nf-core/seqcoverage" src="docs/images/nf-core-seqcoverage_logo_light.png">
  </picture>
</h1>[![GitHub Actions CI Status](https://github.com/nf-core/seqcoverage/actions/workflows/ci.yml/badge.svg)](https://github.com/nf-core/seqcoverage/actions/workflows/ci.yml)
[![GitHub Actions Linting Status](https://github.com/nf-core/seqcoverage/actions/workflows/linting.yml/badge.svg)](https://github.com/nf-core/seqcoverage/actions/workflows/linting.yml)[![AWS CI](https://img.shields.io/badge/CI%20tests-full%20size-FF9900?labelColor=000000&logo=Amazon%20AWS)](https://nf-co.re/seqcoverage/results)[![Cite with Zenodo](http://img.shields.io/badge/DOI-10.5281/zenodo.XXXXXXX-1073c8?labelColor=000000)](https://doi.org/10.5281/zenodo.XXXXXXX)
[![nf-test](https://img.shields.io/badge/unit_tests-nf--test-337ab7.svg)](https://www.nf-test.com)

[![Nextflow](https://img.shields.io/badge/nextflow%20DSL2-%E2%89%A524.04.2-23aa62.svg)](https://www.nextflow.io/)
[![run with conda](http://img.shields.io/badge/run%20with-conda-3EB049?labelColor=000000&logo=anaconda)](https://docs.conda.io/en/latest/)
[![run with docker](https://img.shields.io/badge/run%20with-docker-0db7ed?labelColor=000000&logo=docker)](https://www.docker.com/)
[![run with singularity](https://img.shields.io/badge/run%20with-singularity-1d355c.svg?labelColor=000000)](https://sylabs.io/docs/)
[![Launch on Seqera Platform](https://img.shields.io/badge/Launch%20%F0%9F%9A%80-Seqera%20Platform-%234256e7)](https://cloud.seqera.io/launch?pipeline=https://github.com/nf-core/seqcoverage)

[![Get help on Slack](http://img.shields.io/badge/slack-nf--core%20%23seqcoverage-4A154B?labelColor=000000&logo=slack)](https://nfcore.slack.com/channels/seqcoverage)[![Follow on Twitter](http://img.shields.io/badge/twitter-%40nf__core-1DA1F2?labelColor=000000&logo=twitter)](https://twitter.com/nf_core)[![Follow on Mastodon](https://img.shields.io/badge/mastodon-nf__core-6364ff?labelColor=FFFFFF&logo=mastodon)](https://mstdn.science/@nf_core)[![Watch on YouTube](http://img.shields.io/badge/youtube-nf--core-FF0000?labelColor=000000&logo=youtube)](https://www.youtube.com/c/nf-core)

## Introduction

**nf-core/seqcoverage** is a bioinformatics pipeline designed to visualize sequencing coverage of viral reads. Users can select from a predefined set of genomes or specify any genome available in the NCBI RefSeq dataset using its accession number. The pipeline generates a coverage plot for the selected virus, providing clear insights into sequencing depth and distribution.

1. Sample QC ([`FastQC`](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/))  
2. Read classification to viral database ([`Kraken2`](https://ccb.jhu.edu/software/kraken2/))  
3. Filter reads for virus of interest  
4. Align reads to chosen virus genome ([`Minimap2`](https://github.com/lh3/minimap2/))  
5. Generate coverage graphs ([`Samtools coverage`](http://www.htslib.org/doc/samtools))

## Usage

> [!NOTE]
> If you are new to Nextflow and nf-core, please refer to [this page](https://nf-co.re/docs/usage/installation) on how to set-up Nextflow.Make sure to [test your setup](https://nf-co.re/docs/usage/introduction#how-to-run-a-pipeline) with `-profile test` before running the workflow on actual data.

First, prepare a samplesheet with your input data that looks as follows:

`samplesheet.csv`:

```csv
sample,fastq_1,fastq_2
CONTROL_PAIRED_ENDS,S1_L002_R1_001.fastq,S1_L002_R2_001.fastq
CONTROL_SINGLE_END,S1_L002_001.fastq,
```
Each row represents a pair of fastq files (paired-end sequencing data). The input files should be in fastq or fastq.gz format.

Now, you can run the pipeline using:

```bash
nextflow run nf-core/seqcoverage \
  -profile <docker/singularity/.../institute> \
  -c custom.conf \
  --input samplesheet.csv \
  --outdir <OUTDIR>
```

Example `custom.conf` might look like this:

```bash
params {
  viruses = ['COVID_OC43', 'SARS_CoV_2', 'RSV_A']
  kraken2_db = 'path/to/kraken2db'
  viruses_csv = 'pipeline/dir/assets/viruses.csv'
  minimap2_db = 'path/to/minimap2db.fasta'
}
```

Full list of in-build viruses available for use are within the `viruses.csv` file in assets and are as following:
- SARS_CoV_2
- InfluenzaA
- InfluenzaB
- RSV_A
- Rhinovirus_A
- Rhinovirus_B
- Rhinovirus_C
- Rhinovirus_NAT001
- Parainfluenza1
- Parainfluenza3
- Parainfluenza4
- Human_Metapneumovirus
- Adenovirus2
- Adenovirus5
- Adenovirus1
- Adenovirus7
- Adenovirus35
- AdenovirusD
- AdenovirusB2
- AdenovirusB1
- AdenovirusA
- AdenovirusE
- AdenovirusF
- AdenovirusD
- Adenovirus54
- COVID_OC43
- COVID_229E
- COVID_NL63
- COVID_HKU1
- Bocavirus3
- Mastadenovirus_A
- Mastadenovirus_C
- Monkeypox


It is also possible to use accession numbers for the virus of choice and will depend on availability within the minimap2 database of use (suggested NCBI Viral RefSeq).

> [!WARNING]
> Please provide pipeline parameters via the CLI or Nextflow `-params-file` option. Custom config files including those provided by the `-c` Nextflow option can be used to provide any configuration _**except for parameters**_; see [docs](https://nf-co.re/docs/usage/getting_started/configuration#custom-configuration-files).

For more details and further functionality, please refer to the [usage documentation](https://nf-co.re/seqcoverage/usage) and the [parameter documentation](https://nf-co.re/seqcoverage/parameters).


## Pipeline Parameters

### **Input and Output Options**
- **`input`**: Path to input samplesheet. (csv)
- **`outdir`**: Directory for pipeline output. 

### **Pipeline-Specific Options**
- **`viruses`**: List of target viruses for analysis. (eg. viruses = ['COVID_OC43', 'SARS_CoV_2', 'RSV_A'])
- **`clusterOpts`**: Additional options for cluster execution.
- **`kraken2_db`**: Path to the Kraken2 database.
- **`viruses_csv`**: CSV file containing virus metadata. (in-build list available in assets folder or the pipeline)
- **`minimap2_db`**: Path to the Minimap2 reference genome.

### **Configuration & Validation**
- **`config_profile_name`**: Custom profile name.
- **`config_profile_description`**: Profile description.
- **`config_profile_contact`**: Contact information for profile.
- **`config_profile_url`**: URL for profile documentation.
- **`validate_params`**: Enable schema validation (`true` by default).

### **Pipeline Execution & Output**
- **`publish_dir_mode`**: Mode for output file handling (`copy` by default).
- **`email`**: Email address for notifications.
- **`email_on_fail`**: Send email only on failure.
- **`plaintext_email`**: Send email in plaintext format.
- **`monochrome_logs`**: Disable colored logs if `true`.
- **`hook_url`**: Webhook URL for notifications.
- **`help` / `help_full`**: Show help messages.
- **`version`**: Show pipeline version.

### **MultiQC Options**
- **`multiqc_config`**: Custom MultiQC config file.
- **`multiqc_title`**: Title for the MultiQC report.
- **`multiqc_logo`**: Custom logo for MultiQC.
- **`max_multiqc_email_size`**: Maximum email size for MultiQC reports (`25MB`).
- **`multiqc_methods_description`**: Description of methods used in MultiQC.

### **Execution Profiles**
#### **Debugging**
- **Profile**: `debug`
- **Description**: Enables debugging logs and keeps temporary files.

#### **Containerized Execution**
- **Profile**: `docker`  
  - Runs the pipeline using Docker.
- **Profile**: `singularity`  
  - Uses Singularity for containerization.

#### **Cluster Execution**
- **Profile**: `slurm`
  - Runs jobs on a Slurm cluster.


## Pipeline output

The pipeline generates several output files, with the most important being the HTML report. This report provides a detailed summary of the analysis results, including the presence of majority and minority variants of mutations as defined by the HIVdb Stanford database.

### Key Outputs
- **Coverage Graphs**: Samtools coverage graphs for each chosen virus per sample
  - **Location**: `generate_coverage/`
- **FastQC Reports**: Quality control reports generated by FastQC for the input sequencing data.
  - **Location**: `fastqc/`
- **Kraken2 Classification**: Files for kraken2 classification including kraken2 report, classified and unclassified reads
  - **Location**: `kraken2_kraken2/`
- **Minimap2 Alignment**: Minimap2 alignment files for each sample including index files
  - **Location**: `minimap2_align/`
- **Split Reads**: Split reads for each sample by the viral genome of choice
  - **Location**: `split_by_genome/`
- **MultiQC Report**: MultiQC report summarizing the results of the pipeline
  - **Location**: `multiqc/`
- **Pipeline Info**: Information about the pipeline run including the command and parameters used
  - **Location**: `pipeline_info/`

## Credits

nf-core/seqcoverage was originally written by Magdalena Dabrowska.

We thank the following people for their extensive assistance in the development of this pipeline:

<!-- TODO nf-core: If applicable, make list of people who have also contributed -->

## Contributions and Support

If you would like to contribute to this pipeline, please see the [contributing guidelines](.github/CONTRIBUTING.md).

For further information or help, don't hesitate to get in touch on the [Slack `#seqcoverage` channel](https://nfcore.slack.com/channels/seqcoverage) (you can join with [this invite](https://nf-co.re/join/slack)).

## Citations

<!-- TODO nf-core: Add citation for pipeline after first release. Uncomment lines below and update Zenodo doi and badge at the top of this file. -->
<!-- If you use nf-core/seqcoverage for your analysis, please cite it using the following doi: [10.5281/zenodo.XXXXXX](https://doi.org/10.5281/zenodo.XXXXXX) --><!-- TODO nf-core: Add bibliography of tools and data used in your pipeline -->

An extensive list of references for the tools used by the pipeline can be found in the [`CITATIONS.md`](CITATIONS.md) file.

You can cite the `nf-core` publication as follows:

> **The nf-core framework for community-curated bioinformatics pipelines.**
>
> Philip Ewels, Alexander Peltzer, Sven Fillinger, Harshil Patel, Johannes Alneberg, Andreas Wilm, Maxime Ulysse Garcia, Paolo Di Tommaso & Sven Nahnsen.
>
> _Nat Biotechnol._ 2020 Feb 13. doi: [10.1038/s41587-020-0439-x](https://dx.doi.org/10.1038/s41587-020-0439-x).
