package Tie::Number::Formatted;

use 5.14.0;
use strict;
use warnings FATAL => 'all';
use utf8;

use version 0.77; our $VERSION = qv('v0.2.2');

use Scalar::Util qw(looks_like_number);

use Number::Format::FixedLocale;
#use Data::Dumper;
use Carp;

use enum qw{ false true };

use overload
    '""' => \&stringify,
    '0+' => \&numeric,
    '+' => \&plus,
    '-' => \&minus,
    fallback => 1
    ;

=encoding utf8

=head1 NAME

Tie::Number::Formatted - Numbers that stringify formatted

=head1 VERSION

Version 0.2.2

=cut

sub defaults
{
    my $class = shift;
    return (
	currency => true,
	symbol	=> '£ ',
	precision => 2,
    );
}

sub new
{
    my $class = shift;
    my $value = shift;
    my $self = $class->TIESCALAR(@_);
    $self->{value} = $value;
}

=head1 SYNOPSIS

    use Tie::Number::Formatted;

    tie my $number, 'Tie::Number::Formatted';
    $number = 12345.67;
    say $number;    # prints "£ 12,345.67"
    $number /= 100;
    say $number;    # prints "£ 123.46"

    tie my $number, 'Tie::Number::Formatted', (
	symbol    => '$'    # default is '£ '
	precision => 4	    # default is 2
    );
    $number = 12345.67;
    say $number;    # prints "$12,345.6700"
    

=head1 EXPORT

Nothing is exported.

=head1 DEPENDENCIES

Perl version 5.14.0 or higher

L<Number::Format> to do the actual formatting

L<Scalar::Util> for looks_like_number

L<Carp> for warnings

=head1 SYNTAX

This ties a scalar in such a way that normal numeric operations
work on it but that it prints according to the required format.

=head2 Tying a scalar

    tie my $number, 'Tie::Number::Formatted', @options;

=head2 Options

=over

=item symbol

This is the symbol for your currency.  It defaults to C<"£ ">
but can be set, for example to C<"USD "> or C<"$ ">.  If you don't want
the extra space, simply set it to C<"£"> or C<"$">.

=item precision

This is the number of digits after the decimal point.  If you set this
to C<0>, it will not print the decimal point.

=back

=head2 Beware

If a tied scalar is assigned to another scalar, the new scalar
will still have the same magic.  However it will not be tied so
reassigning it will break the magic.

For example:

    tie my $number, 'Tie::Number::Formatted';
    $number = 123.45;
    my $other = number;
    say $number;    # "£ 123.45"
    $number = 100;
    say $number;    # "£ 100.00"
    say $other;	    # "£ 123.45"
    $other = 100;
    say $other;	    # "100"
    

=cut

sub TIESCALAR
{
    my $class = shift;
    my $self = {};
    my %options = @_ == 1 ? %{$_[0]} : @_;
    %options = ($class->defaults, %options);
    $self->{value} = 0;
    $self->{options} = \%options;
    bless $self, $class;
}

sub FETCH
{
    shift;
}

sub STORE
{
    my $self = shift;
    my $val = shift // '';
    carp qq(Argument "$val" isn't numeric) unless looks_like_number $val;
    no warnings 'numeric';
    $self->{value} = $val + 0;
}

sub numeric
{
    my $self = shift;
    return $self->{value};
}

sub stringify
{
    my $self = shift;
    my $val = $self->{value};
    my $format = new Number::Format::FixedLocale(
	p_sep_by_space => 0,
	n_sep_by_space => 0,
    );
    return '' unless $self->{value};
    return $format->format_price(
	abs $self->{value},
	$self->{options}{precision},
	$self->{options}{symbol},
    );
}

sub plus
{
    my ($self, $other, $swap) = @_;
    my $result = $self->{value} + ($other // 0);
    my $class = ref $self;
    return $class->new($result, $self->{options});
}

sub minus
{
    my ($self, $other, $swap) = @_;
    my $result = $self->{value} - ($other // 0);
    $result = -$result if $swap;
    my $class = ref $self;
    return $class->new($result, $self->{options});
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


