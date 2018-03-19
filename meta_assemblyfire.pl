#!/bin/env perl

use strict;
use warnings;

my $pipedir = '~/git/meta_assembly_pipe';

my %p = ();
my @stage = (
    glob("./src/*.fastq")
    );
foreach my $file (@stage){
    my @p = split(/\// , $file);
    my @u = split(/_+/, $p[-1]);
    my $sid = $u[0];
    #$sid = 'SID' . $sid;
    if($file =~ m/R1/){
	$p{$sid}{'left'} = $file;
    }elsif($file =~ m/R2/){
	$p{$sid}{'right'} = $file;
    }
}
foreach my $s (keys %p){
    system("perl $pipedir/meta_assembly_pipe.pl $p{$s}{'left'} $p{$s}{'right'} $s");
    ## Optional cleanup
    my @torm = ('*.fastq', '*hist*');
    foreach(@torm){
	system("rm $_");
    }
}
