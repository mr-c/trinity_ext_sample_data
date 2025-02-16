#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use File::Basename;
use lib ("$ENV{TRINITY_HOME}/PerlLib");
use Process_cmd;


my $usage = "usage: $0 (RSEM|eXpress|kallisto|salmon) samples.txt Trinity.fasta\n\n";


my $method = $ARGV[0] or die $usage;
unless ($method =~ /^(RSEM|eXpress|kallisto|salmon)$/i) {
    die $usage;
}
my $samples_file = $ARGV[1] or die $usage;
my $trinity_fasta = $ARGV[2] or die $usage;

my $utildir = "$ENV{TRINITY_HOME}/util";

main: {

    &process_cmd("ln -sf $trinity_fasta .");

    $trinity_fasta = basename($trinity_fasta);
    
    my @samples;
    my @global_params;
    {
        open (my $fh, $samples_file) or die $!;
        while (<$fh>) {
            chomp;
            unless (/\w/) { next; }
            if (/^\#/) { next; }
            if (/^\-/) {
                push (@global_params, $_);
            }
            else {
                my ($sample_name, $left_fq, $right_fq) = split(/\s+/);
                unless ($left_fq) {
                    die "Error, not able to parse line: $_";
                }
                $left_fq = &ensure_full_path($left_fq);
                $right_fq = &ensure_full_path($right_fq) if $right_fq;
                
                my @local_params;
                
                if ($left_fq && $right_fq) {
                    push (@local_params, "--left $left_fq --right $right_fq");
                }
                else {
                    push (@local_params, "--single $left_fq")
                }
                    
                push (@samples, [$sample_name, @local_params]);
                
            }
        }
        close $fh;
    }
    
    my @trans_results;
    
    foreach my $sample (@samples) {
        my ($sample_name, @local_params) = @$sample;

        my $cmd = "$utildir/align_and_estimate_abundance.pl --transcripts $trinity_fasta --prep_reference "
            . " @local_params @global_params";
        
        my $outdir = "$method-$sample_name";

        if ($method eq 'RSEM') {
            $cmd .= " --est_method RSEM --output_dir $outdir --aln_method bowtie2 --coordsort_bam ";
            
            push (@trans_results, "$outdir/RSEM.isoforms.results");
            
        }
        elsif ($method =~ /eXpress/i) {
            $cmd .= " --est_method eXpress --output_dir $outdir --aln_method bowtie2 ";
            push (@trans_results, "$outdir/results.xprs");
        }
        elsif ($method eq 'kallisto') {
            $cmd .= " --est_method kallisto --output_dir $outdir ";
            push (@trans_results, "$outdir/abundance.tsv");
        }
        elsif($method eq 'salmon') {
            my $salmon_idx_type = $1;
            $cmd .= " --est_method salmon --output_dir $outdir";
            push (@trans_results, "$outdir/quant.sf");
        }
        else {
            # shouldn't ever get here.
            die "error - method $method not recognized";
        }
        
        &process_cmd($cmd);
        
    }
    
    ## generate matrices.
    my $cmd = "$utildir/abundance_estimates_to_matrix.pl --gene_trans_map $trinity_fasta.gene_trans_map --est_method $method --out_prefix $method --name_sample_by_basedir @trans_results";
    &process_cmd($cmd);
    

    exit(0);
}

