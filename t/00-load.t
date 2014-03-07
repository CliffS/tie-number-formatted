#!perl -T
use 5.14.0;
use strict;
use warnings FATAL => 'all';
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Tie::Number::Formatted' ) || print "Bail out!\n";
}

diag( "Testing Tie::Number::Formatted $Tie::Number::Formatted::VERSION, Perl $], $^X" );
