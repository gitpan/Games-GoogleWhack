use Test;
BEGIN { plan tests => 2 };
use Games::GoogleWhack;

my $gw = Games::GoogleWhack->new();

my ($results, $unlisted, $is_google_whack) =
	$gw->num_google_results('sex', 'love');

ok($results > 100);
ok(not $gw->errstr);
