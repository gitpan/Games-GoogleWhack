#!/usr/bin/perl -w

# $Revision: 1.3 $
# $Id: check2words4googlewhack.pl,v 1.3 2002/02/24 10:32:10 afoxson Exp $

# check2words4googlewhack.pl - checks if two words are a googlewhack
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

use strict;
use blib;
use Games::GoogleWhack;

die "Usage: $0 [word] [word]\n" unless scalar @ARGV == 2;

my $googlewhack    = Games::GoogleWhack->new();
my $is_googlewhack = $googlewhack->is_googlewhack(@ARGV);

die $googlewhack->errstr if $googlewhack->errstr;

if ($is_googlewhack)
{
	print "You've found a GoogleWhack! Congrats! :-)\n";
}
else
{
	print "No GoogleWhack. Sorry :-(\n";
}
