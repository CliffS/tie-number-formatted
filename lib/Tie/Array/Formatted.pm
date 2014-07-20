package Tie::Array::Formatted;

use 5.14.0;
use strict;
use warnings FATAL => 'all';
use utf8;

use version 0.77; our $VERSION = qv('v0.1.1');

use Scalar::Util qw(looks_like_number);

use Data::Dumper;
use Carp;

use enum qw{ false true };

=head1 NAME

Tie::Array::Formatted - An array of self-formatting numbers

=head1 VERSION

Version 0.1.1

=cut

sub format($)
{
    my $self = shift;
    my $value = shift;
    if (looks_like_a_number $value)
    {
	tie my $num, 'Tie::Number::Formatted', $self->{options};
	$num = $value;
	return $num;
    }
    else {
	return $value;
    }
}

=head1 SYNOPSYS

    use Tie::Array::Formatted;

    tie my @array, 'Tie::Array::Formatted';
    push @array, (100, 123, 123.456);
    print "@array\n";	# prints "£ 100.00 £ 123.00 £ 123.45"

=head1 DEPENDENCIES

Perl version 5.14.0 or higher

L<Tie::Number::Formatted>

L<Scalar::Util> for looks_like_number

=head1 SYNTAX

This ties an array so that all values
are automatically tied to Tie::Number::Formatted if they
look like numbers.  Otherwise they are simply stored as is.

=head2 Tying an array

    tie my @array, 'Tie::Array::Formatted', @options;

=head2 Options

For all options, see L<Tie::Number::Formatted>.  All numbers in
the array will be formatted according to these options.

=cut

sub TIEARRAY
{
    my $class = shift;
    my %options = @_ == 1 ? %{$_[0]} : @_;
    %options = (Tie::Number::Formatted->defaults, %defaults);
    my $self = {
	array => [],
	options => \%options,
    };
    bless $self, $class;
}

sub STORE
{
    my $self = shift;
    my ($index, $value) = @_;
    $self->{array}[$index] = $self->format($value);
}

sub FETCHSIZE
{
    my $self = shift;
    my $array = $self->{array};
    return scalar @$array;
}

sub STORESIZE
{
    my $self = shift;
    my $size = shift;
    my $array = $self->{array};
    $#$array = $size;
}

sub FETCH
{
    my $self = shift;
    my $index = shift;
    return $self->{array}[$index];
}

sub CLEAR
{
    my $self = shift;
    my $array = $self->{array};
    $array = [];
}

sub POP 
{
    my $self = shift;
    my $array = $self->{array};
    pop @$array;
}

sub PUSH
{
    my $self = shift;
    my $value = shift;
    my $array = $self->{array};
    push @$array, $self->format($value);
}

sub SHIFT
{
    my $self = shift;
    my $array = $self->{array};
    shift @$array;
}

sub UNSHIFT
{
    my $self = shift;
    my $value = shift;
    my $array = $self->{array};
    unshift @$array, $self->format($value);
}

sub EXISTS
{
    my $self = shift;
    my $index = shift;
    my $array = $self->{array};
    exists $array->[$index];
}

sub DELETE
{
    my $self = shift;
    my $index = shift;
    my $array = $self->{array};
    delete $array->[$index];
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


