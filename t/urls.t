use Test;
BEGIN { plan tests => 3 };
use Games::GoogleWhack;

my $gw = Games::GoogleWhack->new();

ok($gw->_google_url eq 'http://www.google.com/search?q=');
ok($gw->_googlewhack_url eq 'http://www.googlewhack.com/tally.pl');
ok($gw->_dictionary_url eq 'http://www.dictionary.com/search?q=');
