# $Revision: 1.3 $
# $Id: GoogleWhack.pm,v 1.3 2002/02/24 10:32:08 afoxson Exp $

# Games::GoogleWhack
# Copyright (c) 2002 Adam J. Foxson. All rights reserved.

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

package Games::GoogleWhack;

use strict;
use Carp;
use LWP::UserAgent;
use HTTP::Request;
use vars qw($VERSION);

($VERSION) = '$Revision: 1.3 $' =~ /\s+(\d+\.\d+)\s+/;

local $^W;

sub new
{
	my $type      = shift;
	my $useragent = shift || 'Mozilla/5.0',
	my $class     = ref($type) || $type;
	my $self      =
	{
		_google_url      => 'http://www.google.com/search?q=',
		_dictionary_url  => 'http://www.dictionary.com/search?q=',
		_googlewhack_url => 'http://www.googlewhack.com/tally.pl',
		_useragent       => undef,
		errstr           => undef,
	};

	bless $self, $class;

	$self->_useragent($useragent);

	return $self;
}

sub _url_to_domain
{
	shift;
	my $url = shift;

	if ($url =~ m!http://(.+)/!)
	{
		return $1;
	}
	else
	{
		die "Couldn't convert $url to domain";
	}
}

sub is_googlewhack
{
	my $self     = shift;
	my @words    = @_;
	my @unlisted = ();

	for my $word (@words)
	{
		unless ($self->is_in_dictionary($word))
		{
			croak $self->errstr if $self->errstr;
			push @unlisted, $word;
		}
	}

	return (undef, \@unlisted, undef) if @unlisted;

	my $results = $self->num_google_results(@words);
	croak $self->errstr if $self->errstr;

	if (not $results)     { return ($results, undef, undef) }
	elsif ($results == 1) { return ($results, undef, 1) }
	else                  { return ($results, undef, undef) }
}

sub errstr
{ 
	my $self = shift;

	return $self->{errstr};
}

sub _set_errstr
{ 
	my ($self, $errstr) = @_;

	$self->{errstr} = $errstr;

	return undef;
}

sub _useragent
{
	my ($self, $useragent) = @_;

	unless (defined $self->{_useragent})
	{
		my $ua = LWP::UserAgent->new;
		$ua->agent($useragent);

		$self->{_useragent} = $ua;
	}

	return $self->{_useragent};
}

sub _google_url
{
	my $self = shift;

	$self->{_google_url} = shift if @_;

	return $self->{_google_url};
}

sub _googlewhack_url
{
	my $self = shift;

	$self->{_googlewhack_url} = shift if @_;

	return $self->{_googlewhack_url};
}

sub _dictionary_url
{
	my $self = shift;

	$self->{_dictionary_url} = shift if @_;

	return $self->{_dictionary_url};
}

sub submit_to_googlewhack
{
	croak "submit_to_googlewhack needs 5 arguments" unless scalar @_ == 6;

	my $self                                   = shift;
	my ($word1, $word2, $name, $country, $url) = @_;
    my $ua                                     = $self->_useragent;
    my $request                                = new HTTP::Request 'POST';

    $request->url($self->_googlewhack_url);
    $request->content("whack=$word1+$word2&op=Stack&" .
        "name=$name&country=$country&url=$url");

    my $response = $ua->request($request);

    $self->_set_errstr('');

	if ($response->is_success)
	{
		my $content = $response->content;

		if ($content =~ /Your Whack Has Been Added/)
			{ return 1 }
		elsif ($content =~ /Someone else already reported that Whack/)
			{ return }
		else
		{
			$self->_set_errstr('Unrecognized response from ' .
				$self->_url_to_domain($self->_googlewhack_url));
			return;
		}	
	}
	else
	{
		$self->_set_errstr('Unable to query ' .
			$self->_url_to_domain($self->_googlewhack_url));
		return;
	}
}

sub is_in_dictionary
{
	my ($self, $word) = @_;
	my $ua            = $self->_useragent;
	my $request       = HTTP::Request->new('GET',
						$self->_dictionary_url . "$word");
	my $response      = $ua->request($request);

	$self->_set_errstr('');

	if ($response->is_success)
	{
		my $content = $response->content;

		if ($content =~ /No entry found for/)   { return }
		elsif ($content =~ /entries found for/) { return 1 }
		elsif ($content =~ /entry found for/)   { return 1 }
		else
		{
			$self->_set_errstr('Unrecognized response from ' .
				$self->_url_to_domain($self->_dictionary_url));
			return;
		}	
	}
	else
	{
		$self->_set_errstr('Unable to query ' .
			$self->_url_to_domain($self->_dictionary_url));
		return;
	}
}

sub num_google_results
{
	my $self            = shift;
	my ($word1, $word2) = @_;
	my $ua              = $self->_useragent;
	my $request         = HTTP::Request->new('GET',
							$self->_google_url . "$word1+$word2");
	my $response        = $ua->request($request);

	$self->_set_errstr('');

	if ($response->is_success)
	{
		my $content = $response->content;

		if ($content =~
			/Results\s<b>\d+<\/b>\s-\s<b>\d+<\/b>
			\sof\s(?:about\s)?<b>([\d,]+)<\/b>/x)
		{
			my $results = $1;
			$results =~ s/,//g;
			return $results;
		}
		elsif ($content =~ /did not match any documents/)
		{
			return;
		}
		else
		{
			$self->_set_errstr('Unrecognized response from ' .
				$self->_url_to_domain($self->_google_url));
			return;
		}	
	}
	else
	{
		$self->_set_errstr('Unable to query ' .
			$self->_url_to_domain($self->_google_url));
		return;
	}
}

1;

__DATA__

__END__

=head1 NAME

Games::GoogleWhack - Finds, verifies, and/or submits GoogleWhack's

=head1 SYNOPSIS

  use Games::GoogleWhack;

  my $googlewhack    = Games::GoogleWhack->new();
  my $is_googlewhack = $googlewhack->is_googlewhack('foo', 'bar');

  die $googlewhack->errstr if $googlewhack->errstr;

  print "You've found a GoogleWhack! Congrats! :-)\n" if $is_googlewhack;

=head1 DESCRIPTION

NOTE: THIS MODULE MAKES EXTERNAL CONNECTIONS TO GOOGLE.COM, DICTIONARY.COM,
and/or GOOGLEWHACK.COM. IT IS THE USER'S RESPONSIBILITY TO ENSURE THAT THEY
ARE IN COMPLIANCE WITH ANY RESPECTIVE TERMS OF USE CLAUSES FOR SITE USAGE.
THE AUTHOR ASSUMES NO LIABILITY FOR THE USE OR MISUSE OF THIS SCRIPT.

Public Methods:

B<new> (constructor)

  gets one optional word as an argument that will be used as
  the useragent, ie "Mozilla/5.0"

B<is_googlewhack>

  gets two mandatory words as arguments
  returns true of undef if scalar context (use scalar context
  only if you don't care why it failed if it returns undef),
  and returns results, unlisted words (array ref), and if it's
  a googlewhack in list context

B<is_in_dictionary>

  get one mandatory word as an argument
  returns false w/ error (error is in errstr), false w/o error
  (word is not listed in dictionary.com), or true (word is in
  dictionary)

B<num_google_results>

  gets two mandatory words as arguments
  returns false w/ error (error is in errstr), false w/o error
  (word yielded no results on google), or true (number of google
  results)
           
B<submit_to_googlewhack>

  gets 5 mandatory arguments: word, word, your name, your country,
  your url returns true (added to googlewhack.com's whack stack
  page), false w/ error (error is in errstr), or false w/o error
  (not added to googlewhack.com's whack stack page; may have
  already been added)

B<errstr>

  gets no arguments
  returns either the text of the error that occured or false
  (no error)

See the README for the introduction.

=head1 TODO

  Add Memoization
  Add support for googlewhack.com's 3rd rule
  (result page can't be wordlist)

=head1 CREDITS

Thanks to Bob O'neill <Oneill.Bob@Grantstreet.com> for bug hunting,
beta testing, submission functionality, and various improvements.

=head1 AUTHOR

Adam J. Foxson, E<lt>afoxson@pobox.comE<gt>

=head1 SEE ALSO

L<perl>.

=cut
