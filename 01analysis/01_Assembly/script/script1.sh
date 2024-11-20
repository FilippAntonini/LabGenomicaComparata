#!/bin/bash

#variables in questo modo dico che le variabili posizionali quindi la prima variabile è assembly la seconda è fastq1 
assembly=$1
fastq1=$2
fastq2=$3
longread=$4

#name creation
outputname=$(basename -s _Raw "$assembly") 

#mapping short reads on assembly e con > lo indirizzo dentro un file.sam
#mapping long reads on assembly
minimap2 -ax sr --MD  -t 5 "$assembly" "$fastq1" "$fastq2" > "$outputname"_sr.sam
minimap2 -ax map-pb --MD  -t 5 "$assembly" "longread" > "$outputname"_pac.sam  
#converting file sam in file bam
samtools view -Sb "$outputname"_sr.sam "$outputname"_sr.bam
samtools view -Sb "$outputname"_pac.sam "$outputname"_pac.bam
#remove file SAM
rm "$outputname"_sr.sam
rm "$outputname"_pac.sam
#sorting and indexing bam file
samtools sort -@5 -o "$outputname"_sr_sorted.bam "$outputname"_sr.bam
samtools sort -@5 -o "$outputname"_pac_sorted.bam "$outputname"_pac.bam

samtools index "$outputname"_sr_sorted.bam 
samtools index "$outputname"_pac_sorted.bam 




