use Test;
BEGIN { plan tests => 2 };
use Games::GoogleWhack;

my $gw   = Games::GoogleWhack->new(undef, 5);
my $skip = 0;
my $result;

eval
{
	$result = $gw->is_googlewhack('sex', 'love');
};

$skip = 'skip host is unreachable' if
	$gw->errstr and $gw->errstr =~ /Unable to query/;

skip($skip, not $result);
skip($skip, not $gw->errstr);
