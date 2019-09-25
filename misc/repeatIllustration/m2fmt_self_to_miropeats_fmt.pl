#!/usr/bin/env perl

use strict;
use warnings;

my $usage = "usage: $0 self.m2fmt\n\n";

my $m2fmt = $ARGV[0] or die $usage;

my @matches;

my $max_coord = 0;
open (my $fh, $m2fmt) or die "Error, cannot open file $m2fmt";
while (<$fh>) {
	chomp;
	my @x = split (/\t/);

	my ($accA, $accB, $lendA, $rendA, $lendB, $rendB, $per_id) = ($x[0], $x[1], $x[17], $x[18], $x[20], $x[21], $x[10]);

	unless ($accA eq $accB) {
		die "Error, doesn't look like a self match: $_";
	}

	my @coords = sort {$a<=>$b} ($lendA, $rendA, $lendB, $rendB);
	my $largest = pop @coords;
	if ($largest > $max_coord) {
		$max_coord = $largest;
	}

	if ($lendA == $lendB && $rendA == $rendB) {
		next; # ignore self diagonal 
	}

	push (@matches, [$accA, $lendA, $rendA, $lendB, $rendB, $per_id]);
	

}

foreach my $match (@matches) {
	my ($accA, $lendA, $rendA, $lendB, $rendB, $per_id) = @$match;

	print join ("\t", $accA, $lendA, $rendA, $max_coord,
				$accA, $lendB, $rendB, $max_coord, $per_id) . "\n";
}


exit(0);


	
