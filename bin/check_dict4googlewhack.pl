#!/usr/bin/perl -w

# $Revision: 1.3 $
# $Id: check_dict4googlewhack.pl,v 1.3 2002/02/24 10:32:10 afoxson Exp $

# check_dict4googlewhack.pl - scans a dictionary for googlewhacks
# Copyright (c) 2002 Adam J. Foxson. All rights reserved.

# NOTE: THIS MODULE MAKES EXTERNAL CONNECTIONS TO GOOGLE.COM, DICTIONARY.COM,
# and/or GOOGLEWHACK.COM. IT IS THE USER'S RESPONSIBILITY TO ENSURE THAT THEY
# ARE IN COMPLIANCE WITH ANY RESPECTIVE TERMS OF USE CLAUSES FOR SITE USAGE.
# THE AUTHOR ASSUMES NO LIABILITY FOR THE USE OR MISUSE OF THIS SCRIPT.

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

$|++;

use strict;
use blib;
use Games::GoogleWhack;

### -- Begin user configurable
my $sleep      = 1; # how many seconds to sleep between each check
my $dictionary = '/usr/share/dict/words'; # path to dict file, 1 word / line
my $submit     = 0; # submit gw's to googlewhack.com?
### -- End user configurable

my $googlewhack = Games::GoogleWhack->new();
my %skip        = ();

open DICT, $dictionary or die $!;
chomp (my @dict = <DICT>);
close DICT or die $!;

my @dict2 = @dict;

OUTER: for my $word1 (sort {length $b <=> length $a} @dict)
{
	next if defined $skip{$word1};

	INNER: for my $word2 (sort {length $b <=> length $a} @dict2)
	{
		next if defined $skip{$word2};
		next if $word2 eq $word1;

		print "$word1 and $word2" .
			'.' x (79 - ((length $word1) + (length $word2)) - 20);

		my ($results, $unlisted_words, $is_googlewhack) =
			$googlewhack->is_googlewhack($word1, $word2);

		if ($googlewhack->errstr)
		{
			warn $googlewhack->errstr;
			next INNER;
		}

		if ($unlisted_words)
		{
			if (scalar @{$unlisted_words} == 2)
			{
				for my $word (@{$unlisted_words})
				{
					$skip{$word}++;
				}
				print "both unlisted\n";
				next OUTER;
			}

			my $word = (@{$unlisted_words})[0];
			$skip{$word}++;

			if ($word eq $word1)
			{
				print "1st unlisted\n";
				next OUTER;
			}
			else
			{
				print "2nd unlisted\n";
				next INNER;
			}
		}

		if ($is_googlewhack)
		{
			if (not $submit)
			{
				print "GOOGLEWHACK!\n"
			}
			else
			{
				my $submitted =
					$googlewhack->submit_to_googlewhack($word1, $word2,
						'Someone', 'Somewhere', '');

				die $googlewhack->errstr if $googlewhack->errstr;

				if ($submitted) { print "GW! Sumbitted!\n" }
				else            { print "GW! Submit error\n" }
			}
		}
		elsif (not $results)
		{
			print "0 results\n"
		}
		else
		{
			print "$results results\n"
		}
	
		sleep $sleep;
	}
}
