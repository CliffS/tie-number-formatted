use 5.14.0;
use strict;
use warnings FATAL => 'all';
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Tie::Number::Formatted',
    license             => 'Artistic_2_0',
    dist_author         => q{Cliff Stanford <cpan@may.be>},
    dist_version_from   => 'lib/Tie/Number/Formatted.pm',
    release_status      => 'stable',
    configure_requires => {
        'Module::Build' => 0,
    },
    build_requires => {
        'Test::More' => 0,
    },
    requires => {
        #'ABC'              => 1.6,
        #'Foo::Bar::Module' => 5.0401,
    },
    add_to_cleanup     => [ 'Tie-Number-Formatted-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
