package Tie::Array::Formatted;

use 5.14.0;
use strict;
use warnings FATAL => 'all';
use utf8;

use version 0.77; our $VERSION = qv('v0.0.1');

use Tie::Hash;
use Scalar::Util qw(looks_like_number);

use parent q(Tie::ExtraHash);

use Data::Dumper;
use Carp;

use enum qw{ false true };

=head1 NAME

Tie::Hash::Formatted - A hash containing self-formatting numbers

=head1 VERSION

Version 0.0.1

=cut

sub format($)
{
    my $self = shift;
    my $value = shift;
    if (looks_like_a_number $value)
    {
	tie my $num, 'Tie::Number::Formatted', $self->[1];
	$num = $value;
	return $num;
    }
    else {
	return $value;
    }
}

=head1 SYNOPSYS

    use Tie::Hash::Formatted;

    tie my %hash, 'Tie::Hash::Formatted';
    $hash{one} = 1;
    say $hash{one};	# prints "£ 1.00"

=head1 DEPENDENCIES

Perl version 5.14.0 or higher

L<Tie::Number::Formatted>

L<Scalar::Util> for looks_like_number

=head1 SYNTAX

This ties a hash so that the keys are normal but the values
are automatically tied to Tie::Number::Formatted if they
look like numbers.  Otherwise they are simply stored as is.

=head2 Tying a hash

    tie my %hash, 'Tie::Hash::Formatted', @options;

=head2 Options

For all options, see L<Tie::Number::Formatted>.  All numbers in
the hash will be formatted according to these options.

=cut

sub TIEHASH
{
    my $class = shift;
    my %options = @_ == 1 ? %{$_[0]} : @_;
    %options = (Tie::Number::Formatted->defaults, %defaults);
    bless [ {}, \%options ], $class;
}

sub STORE
{
    my $self = shift;
    my ($key, $value) = @_;
    $self->[0]{$key} = $self->format($value);
}

=head1 AUTHOR

Cliff Stanford, C<< <cpan@may.be> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-tie-number-formatted at rt.cpan.org>, or through
the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Tie-Number-Formatted>.
I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Tie::Number::Formatted

=head1 LICENSE AND COPYRIGHT

Copyright 2014 Cliff Stanford.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of Tie::Number::Formatted


