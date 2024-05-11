#!/bin/bash

#defining parameters
type=
short_reads_se=
long_reads=
short_reads_forward=
short_reads_reverse=

if [[ $# -eq 6 ]] ; then echo "Enter the required argument"; exit 1; fi
 

#a help menu showing how to use the script and what are the required arguments are.
usage(){
cat << EOF
${0} -se short_single_end.fastq -l long_reads.fastq -pe forward_short.fastq reverse_short.fastq 
 please specify:
 --> single end short reads with the flag -se 
 --> paired end short reads with the flag -pe 
 --> type of the short reads if they are single or paired end with the flag -t

EOF
}


#Count all the args passed into the script and continue looping while we have them:
while [[ $# -gt 0 ]]
do
	case "$1" in 
           -h|--help|help)
		   usage
                
		exit 1
       	        ;;
	   -pe)
		#set the value of of type so we can use later in the script
		type=pe
		short_reads_forward="${2:-}"
		short_reads_reverse="${3:-}"

		#check if -t flag has been given a value or not
		([[ -z "$short_reads_forward" ]] || [[ -z "$short_reads_reverse" ]]) &&          \                                        printf "%s must have a value\n\n" "$1" 1>&2 && usage 1>&2 && exit 1

		#check if -t flag have been given the correct argument
	        [[ ! -f $short_reads_forward || $short_reads_forward !== (*.fastq|*.fastq.gz) ]] &&  \                                    echo 'must be a fastq file' && exit 1
                
		shift 3
		;;
	   -se)
                #set the value to
	        type=se	
		short_reads_se="${2:-}"

	        #check if -s flag has been given a value or not
		[[ -z $short_reads_se ]] && printf "%s -s must have a value and be a viable file path\n\n" 1>&2 && exit

		#check if -s has been given a viable path to fastq files
		[[ ! -f $short_reads_se || $short_reads_se !== (*.fastq|*.fastq.gz) ]] && printf  \                                           "%s must be a fastq file\n\n" && exit 1	 

		shift 2

		;;
	   -l)
	     #set the value to
	     long_reads="${2:-}"

	     #check if the -t has been given a value or not
	     [[ -z $long_reads ]] && printf "%s -l must have a value and be a viable path\n\n" >&2 && exit 1

	     #check if -l has been given a viable path to fastq files
	     [[ ! -f $long_reads || $long_reads !== (*.fastq|*.fastq.gz) ]] && printf \
		     "%s must be a fastq file\n\n" && exit 1
	     
	     shift 2

	        ;;
	    *)
	     printf "%s enter a valid option\n\n" >&2 && usage >&2 && exit 1
	       
	        ;;

       esac 

done

#generating a report of base quality using FastQC:
quality_control(){

	fastqc "$short_reads_se" "$short_reads_forward" "$short_reads_reverse"
}

quality_control

#trimming low quality bases using Trimmomatic

#trimming pairend short reads:

trimming_pe(){
	java -jar trimmomatic-0.39.jar PE "$short_reads_forward" "$short_read_reverse" paired_${short_read_forward} unpaired_${short_read_forward} paired_${short_read_reverse} unpaired_${short_read_reverse} ILLUMINACLIP:TruSeq3-PE.fa:2:30:10:2:True LEADING:3 TRAILING:3 MINLEN:50

}

#trimming single end reads:

trimming_se(){
         java -jar trimmomatic-0.35.jar SE -phred33 "$short_reads_se" output_${short_reads_se} ILLUMINACLIP:TruSeq3-SE:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:50

}

#checking the type of short reads 

if [[ $type == paired ]]
do
	trimming_pe
else
	trimming_se
done

#checking quality base of ONT using NanoPlot:

nanoplot_qc(){

NanoPlot --fastq "$long_reads"	-o qc_nanoplot_report

}

nanoplot_qc

#Adaptor removal and demultiplexing with Porechore:

adaptor_removal(){

porechop -i "$long_reads" -b demultiplex_output

}

adaptor_removal

#trimming and filtering of nanopore:

trimming_filtering(){

NanoFilt  -l 500 -q 6 -headcrop 10	

}
