use Test;
BEGIN { plan tests => 1 };
use Games::GoogleWhack;

my $gw = Games::GoogleWhack->new();

ok($gw->_url_to_domain('http://www.google.com/search?q='));
