use 5.14.0;
use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'Tie::Number::Formatted',
    AUTHOR           => q{Cliff Stanford <cpan@may.be>},
    VERSION_FROM     => 'lib/Tie/Number/Formatted.pm',
    ABSTRACT_FROM    => 'lib/Tie/Number/Formatted.pm',
    LICENSE          => 'Artistic_2_0',
    PL_FILES         => {},
    MIN_PERL_VERSION => 5.14.0,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More' => 0,
    },
    PREREQ_PM => {
	'Number::Format'    => 1.73,
	'Scalar::Util'	    => 1.38,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'Tie-Number-Formatted-*' },
);
