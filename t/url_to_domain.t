use Test;
BEGIN { plan tests => 3 };
use Games::GoogleWhack;

my $gw = Games::GoogleWhack->new();

ok('www.google.com' eq
	$gw->_url_to_domain('http://www.google.com/search?q='));
ok('www.googlewhack.com' eq
	$gw->_url_to_domain('http://www.googlewhack.com/tally.pl'));
ok('www.dictionary.com' eq
	$gw->_url_to_domain('http://www.dictionary.com/search?q='));
