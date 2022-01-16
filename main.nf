params.proj = ""
input_ch = Channel.fromFilePairs("${launchDir}/${params.proj}/*_R{1,2}.fastq.gz")

process align {

  memory '16 GB'
  cpus "8"

  publishDir "${launchDir}/${params.proj}", mode: 'copy'
  container 'XX_ADD_ME_XX'

  input: 
  tuple sample, paths from input_ch 

  output:
  file "${sample}.bam"

  script:
  rg = "\"@RG\\tID:${sample}\\tSM:${sample}\\tLB:${sample}\\tPL:ILLUMINA\""

  """
  bwa mem  -R ${rg} \
                  -t 6 \
                  ${launchDir}/GRCh38-p10/index/BWA/GRCh38-p10 \
                  ${paths[0]} \
                  ${paths[1]} \
                  | sambamba view -S -f bam /dev/stdin \
                  | sambamba sort /dev/stdin -o "${sample}.bam" 2> file.err
  """
}


