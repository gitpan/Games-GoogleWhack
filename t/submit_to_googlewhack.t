use Test;
BEGIN { plan tests => 4 };
use Games::GoogleWhack;

my $gw = Games::GoogleWhack->new();

eval
{
	$gw->submit_to_googlewhack('foo', 'bar');
};
ok($@ =~ /needs at least 2 named arguments/);

eval
{
	$gw->submit_to_googlewhack('word1' => 'bar', 'word2' => 'there', 'name');
};
ok($@ =~ /needs an even number of named arguments/);

eval
{
	$gw->submit_to_googlewhack('word1' => 'bar', 'word2' => 'there', 'nam' => 'foo');
};
ok($@ =~ /Parameter 'nam' is invalid/);

eval
{
	$gw->submit_to_googlewhack('word1' => 'bar', 'name' => 'someone');
};
ok($@ =~ /Parameter 'word2' must be specified/);
