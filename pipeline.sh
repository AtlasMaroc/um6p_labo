#!/bin/bash

#defining parameters

short_read="$1"
long_read="$2"

if [[ $# -eq 0 ]] ; then echo "Enter the required argument"; exit 1; fi

if [[ -z "$1" ]] ; then echo "you must provide short reads filename"; exit 1; fi
if [[ -z "$2" ]] ; then echo "you must provide long reads filename"; exit 1; fi

if [[ ! -f "$1"  ]] ; then echo "$1" "does not exist"; exit 1; fi
if [[ ! -f "$2" ]] ; then echo "$2" "does not exist"; exit 1; fi

if [[ ! "$1" == +(*.fastq|*.fastq.gz) ]] ; then echo "$1 is not a fastq file" ; exit 1; fi
if [[ ! "$2" == +(*.fastq|*.fastq.gz) ]] ; then echo "$2 is not a fastq file" ; exit 1; fi 

#FastQC Quality Control:

check_qualtiy() {
	fastqc "$short_read"
}

chek_qualtiy

