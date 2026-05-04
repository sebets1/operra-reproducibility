#!/usr/bin/env nextflow

/*
 * Minimal workshop demo pipeline:
 * 1. Python centres the values in example_data.csv  → 1_derived.csv
 * 2. R reads 1_derived.csv and produces summary stats → 2_summary.txt
 * 3. Python (polars) processes 1_derived.csv           → 3_processed.csv
 * 4. Quarto collects outputs into an HTML report       → 4_report.html
 *
 * Steps 1 and 2 are sequential: R depends on Python's output.
 */

params.outdir = (params.outdir ?: 'results')

workflow {
  def derived = PY_DERIVE( file('example_data.csv'), file('1_derive.py') )
  def summary = R_SUMMARY( derived, file('2_summary.R') )
  def processed = POLARS_PROCESS( derived, summary, file('3_polars_process.py') )

  FINAL_REPORT(
    file('4_report.qmd'),
    file('example_data.csv'),
    derived,
    summary,
    processed
  )
}

process PY_DERIVE {
  publishDir "${params.outdir}", mode: 'copy'

  input:
  path "example_data.csv"
  path "1_derive.py"

  output:
  path "1_derived.csv"

  script:
  """
  python3 1_derive.py --input example_data.csv --output 1_derived.csv
  """
}

process R_SUMMARY {
  publishDir "${params.outdir}", mode: 'copy'

  input:
  path "1_derived.csv"
  path "2_summary.R"

  output:
  path "2_summary.txt"

  script:
  """
  Rscript 2_summary.R --input 1_derived.csv --output 2_summary.txt
  """
}

process POLARS_PROCESS {
  publishDir "${params.outdir}", mode: 'copy'

  input:
  path "1_derived.csv"
  path "2_summary.txt"
  path "3_polars_process.py"

  output:
  path "3_processed.csv"

  script:
  """
  python3 3_polars_process.py --input 1_derived.csv --summary 2_summary.txt --output 3_processed.csv
  """
}

process FINAL_REPORT {
  publishDir "${params.outdir}", mode: 'copy'

  input:
  path "4_report.qmd"
  path "example_data.csv"
  path "1_derived.csv"
  path "2_summary.txt"
  path "3_processed.csv"

  output:
  path "4_report.html"

  script:
  """
  quarto render 4_report.qmd --to html --output 4_report.html --output-dir .
  """
}
