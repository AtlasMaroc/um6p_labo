This script performs quality control on both short and long nanopore reads. It supports single-end and paired-end short reads, and long reads. The script includes options to specify quality control parameters for filtering and trimming reads. The output includes demultiplexed and filtered long reads, as well as trimmed short reads.

Usage: ./pipeline.sh [options]

Required Options:
* `-se <file.fastq>`: Specify the path to single-end short reads.
* `-pe <file.fastq>`: Specify the path to paired-end short reads.
* `-l <file.fastq>`: Specify the path to long reads.
  
Quality Control Parameters:
* `--nanolen <length>`: Minimum filtration read length for long reads.
* `--minlen <length>`: Minimum filtration read length for short reads.
* `--headcrop <num>`: Number of nucleotides to trim from the start of the long reads.
* `--qbase <score>`: Average read quality score to filter long reads based on.

Output:
The script will create a:
    demultiplexed_reads/
        ├── long_reads_filtered.fastq
    Trimmed short reads files named trimmed_{file.name}.
