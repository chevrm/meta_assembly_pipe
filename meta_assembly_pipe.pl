#!/bin/env perl

use strict;
use warnings;

my ($fwd, $rev, $pref) = (shift, shift, shift);

my $preprocess = 1;
my $k = 31;
my $threads = 38;

if($preprocess==0){
    ## SPADES
    system("metaspades.py -1 $fwd -2 $rev -t $threads -o $pref-metaspades");
}else{
    ## Musket
    system("musket -p $threads -inorder -omulti $pref.musket -k $k 536870912 $fwd $rev");
    system("mv $pref.musket.0 $pref.musket.0.fastq");
    system("mv $pref.musket.1 $pref.musket.1.fastq");
    ## Flash pairs
    system("flash -t $threads -o $pref $pref.musket.0.fastq $pref.musket.1.fastq");
    ## SPADES
    system("metaspades.py --pe1-1 $pref.notCombined_1.fastq --pe1-2 $pref.notCombined_2.fastq --s2 $pref.extendedFrags.fastq -t $threads -o $pref-metaspades");
    ## Rename
    system("cp $pref-spades/contigs.fasta ./$pref-metaspades.fna");
}
