use Test;
BEGIN { plan tests => 2 };
use Games::GoogleWhack;

my $gw   = Games::GoogleWhack->new(undef, 5);
my $skip = 0;
my ($results, $unlisted, $is_google_whack);

eval
{
	($results, $unlisted, $is_google_whack) =
		$gw->num_google_results('sex', 'love');
};

$skip = 'skip host is unreachable' if
	$gw->errstr and $gw->errstr =~ /Unable to query/;

skip($skip, $results > 100);
skip($skip, not $gw->errstr);
