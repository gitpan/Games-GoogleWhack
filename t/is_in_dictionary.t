use Test;
BEGIN { plan tests => 2 };
use Games::GoogleWhack;

my $gw   = Games::GoogleWhack->new(undef, 5);
my $skip = 0;
my $result;

eval
{
	$result = $gw->is_in_dictionary('sex', 'love');
};

$skip = 'skip host is unreachable' if
	$gw->errstr and $gw->errstr =~ /Unable to query/;

skip($skip, $result);
skip($skip, not $gw->errstr);
