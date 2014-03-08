package Tie::Number::Formatted;

use 5.14.0;
use strict;
use warnings FATAL => 'all';
use utf8;

use version 0.77; our $VERSION = qv('v0.0.1');

use Scalar::Util qw(looks_like_number);

use Number::Format;
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

=encoding UTF-8

=head1 NAME

Tie::Number::Formatted - Numbers that stringify formatted

=head1 VERSION

Version 0.0.1

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

=head2 Tying a scalar

This ties a scalar in such a way that normal numeric operations
work on it but that it prints according to the required format.

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
    my $val = shift;
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
    my $format = new Number::Format;
    return $format->format_price(
	abs $self->{value},
	$self->{options}{precision},
	$self->{options}{symbol},
    );
}

sub plus
{
    my ($self, $other, $swap) = @_;
    my $result = $self->{value} + $other;
    my $class = ref $self;
    return $class->new($result, $self->{options});
}

sub minus
{
    my ($self, $other, $swap) = @_;
    my $result = $self->{value} - $other;
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
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut


1; # End of Tie::Number::Formatted


