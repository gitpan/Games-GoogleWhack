use Test;
BEGIN { plan tests => 2 };
use Games::GoogleWhack;

my $gw = Games::GoogleWhack->new();

ok($gw->is_in_dictionary('sex', 'love'));
ok(not $gw->errstr);
