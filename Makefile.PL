use ExtUtils::MakeMaker;

WriteMakefile
(
	'NAME'         => 'Games::GoogleWhack',
	'VERSION_FROM' => 'GoogleWhack.pm',
	'PREREQ_PM'    =>
	{
		'LWP::UserAgent' => '1.62',
		'HTTP::Request'  => '1.23',
	},
	(
		$] >= 5.005 ?
		(
			ABSTRACT_FROM => 'GoogleWhack.pm',
			AUTHOR        => 'Adam J. Foxson <afoxson@pobox.com>',
		) : ()
	),
);
