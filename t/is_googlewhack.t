use Test;
BEGIN { plan tests => 2 };
use Games::GoogleWhack;

my $gw = Games::GoogleWhack->new();

ok(not $gw->is_googlewhack('sex', 'love'));
ok(not $gw->errstr);
