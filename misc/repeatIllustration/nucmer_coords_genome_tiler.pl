#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long qw(:config no_ignore_case bundling);


my $usage = <<__EOUSAGE__;

###############################################################
#
#   --coords   nucmer show-coords output file (show-coords -T -H out.delta > out.coords)
#   --contig   reference contig
#
#   -P        minimum match percent identity
#   -L        minimum match length
#
###############################################################

__EOUSAGE__

	;


my ($coords_file, $refContigAcc);
my $minPerID = 0;
my $minMatchLen = 0;

&GetOptions ( "coords=s" => \$coords_file,
			  "contig=s" => \$refContigAcc,
			  
			  "P=f" => \$minPerID,
			  "L=i" => \$minMatchLen,
			  );

unless ($coords_file && $refContigAcc) {
	die $usage;
}



main: {

	print STDERR "-parsing matches in $coords_file\n";
	my @matches = &parse_matches($coords_file);
	
	print STDERR "-parsed " . scalar (@matches) . " matches\n";
	
	unless (@matches) {
		die "No matches parsed ";
	}

	print STDERR "-tiering matches\n";
	my @tiers = &tier_matches(@matches);
	
	&report_tiers (\@tiers);

	exit(0);
}


####
sub report_tiers {
	my ($tiers_aref) = @_;


	my $tier_pos = 0;
	
	foreach my $tier (@$tiers_aref) {
		$tier_pos++;
	
		my @matches = @$tier;
		foreach my $match (@matches) {
			my ($match_lend, $match_rend, $match_len) = @$match;
			print "$match_lend\t$tier_pos\n"
				. "$match_rend\t$tier_pos\n\n";
		}
	}

	return;
}



####
sub tier_matches {
	my @matches = @_;

	## sort by match length:
	@matches = reverse sort {$a->[2]<=>$b->[2]} @matches;

	my @tiers = ( [ $matches[0] ] );

	for (my $i = 1; $i <= $#matches; $i++) {
		
		my $match = $matches[$i];

		if (! &add_to_existing_tier(\@tiers, $match)) {
			
			## create a new tier:
			push (@tiers, [ $match ] );
		}
	}


	return (@tiers);
}

####
sub add_to_existing_tier {
	my ($tiers_aref, $match) = @_;

	my ($match_lend, $match_rend, $match_len) = @$match;

  TIER:
	foreach my $tier (@$tiers_aref) {

		foreach my $other_match (@$tier) {
			my ($other_lend, $other_rend, $other_len) = @$other_match;
			
			if ($other_lend <= $match_rend && $other_rend >= $match_lend) { # got overlap
				next TIER;
			}
		}

		# if got here, then no overlap at this tier level.
		## add to this tier:
		push (@$tier, $match);
		
		return (1); # added to existing tier.
	}


	return (0); # no position on existing tiers available
}




####
sub parse_matches {
	my ($coords_file) = @_;
	
	my @matches;

	open (my $fh, $coords_file) or die "Error, cannot open file $coords_file";
	while (<$fh>) {

		chomp;
		
		my ($end5_A, $end3_A, $end5_B, $end3_B, $match_len_A, $match_len_B, $per_ID, $accA, $accB) = split (/\t/);

		if ($accA eq $accB && $end5_A == $end5_B) { # self match same coords
			next;
		}

		if ($per_ID < $minPerID) { next; }

		if ($accA eq $refContigAcc && $match_len_A >= $minMatchLen) {
			push (@matches, [$end5_A, $end3_A, $match_len_A]);
		}
		
		if ($accB eq $refContigAcc && $match_len_B >= $minMatchLen) {
			push (@matches, [$end5_B, $end3_B, $match_len_B]);
		}


	}

	close $fh;

	return (@matches);

}

	   
