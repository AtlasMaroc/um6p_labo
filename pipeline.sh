#!/bin/bash

#defining parameters
type=                             
short_read=
long_read= 

if [[ $# -eq 0 ]] ; then echo "Enter the required argument"; exit 1; fi
 

#a help menu showing how to use the script and what the expected arguments are.
usage(){
cat << EOF
${0} -s short_reads.fastq -l long_reads.fastq -t paired|single 
 please specify:
 --> short reads path with the flag -s 
 --> long reads path with the flag -l
 --> type of the short reads if they are single or paired end with the flag -t

EOF
}
#FastQC qualtiy control:
short_qc(){
fastqc "$1"
}


#Count all the args passed into the script and continue looping while we have them:
while [[ $# -gt 0 ]]
do
	case "$1" in 
           -h|--help|help)
		   usage
                
		exit 1
	        ;;
	   -t)
		#set the value of of type so we can use later in the script
		type="${2:-}"
		#check if -t flag has been given a value or not
	        [[ -z "$type" ]] && printf "%s must have a value\n\n" "$1" 1>&2 && usage 1>&2 && exit 1
		#check if -t flag have been given the correct argument
	        [[ ! $type == (single|paired) ]] && echo '-t flag accept only two argument: single or paired' && exit 1
                
		shift 2
		;;
	   -s)
                #set the value to 
		short_reads="${2:-}"
	        #check if -s flag has been given a value or not
		[[ -z $short_reads ]] && printf "%s -s must have a value and be a viable file path\n\n" 1>&2 && exit 1
		#check if -s has been given a viable path to fastq files
		[[ ! -f $short_reads || $short_reads !== (*.fastq|*.fastq.gz) ]] && printf  \                                           "%s must be a fastq file\n\n" && exit 1	 

		shift 2
	   -l)
	     #




#FastQC Quality Control:


