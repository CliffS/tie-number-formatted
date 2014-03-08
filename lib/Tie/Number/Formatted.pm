package Tie::Number::Formatted;

use 5.14.0;
use strict;
use warnings FATAL => 'all';
use utf8;

use version 0.77; our $VERSION = qv('v0.0.1');

use Scalar::Util qw(looks_like_number);

use Number::Format;
use Data::Dumper;
use Carp;

use enum qw{ false true };

use overload
    '""' => \&stringify,
    '0+' => \&numeric,
    '+' => \&plus,
    '-' => \&minus,
    '=' => \&assign,
    fallback => 1
    ;

=head1 NAME

Tie::Number::Formatted - Numbers that stringify formatted

=head1 VERSION

Version 0.0.1

=cut

sub new
{
    my $class = shift;
    my $value = shift;
    my $self = $class->TIESCALAR(@_);
    $self->{value} = $value;
}

sub TIESCALAR
{
    my $class = shift;
    my $self = {};
    my %defaults = (
	currency => true,
	symbol	=> '£ ',
	precision => 2,
    );
    my %options = @_ == 1 ? %{$_[0]} : @_;
    %options = (%defaults, %options);
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
    my $format = new Number::Format(
	-neg_format  => '(x)',
    );
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


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Tie::Number::Formatted;

    my $foo = Tie::Number::Formatted->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 SUBROUTINES/METHODS

=head2 function1

=cut

sub function1 {
}

=head2 function2

=cut

sub function2 {
}

=head1 AUTHOR

Cliff Stanford, C<< <cpan at may.be> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-tie-number-formatted at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Tie-Number-Formatted>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Tie::Number::Formatted


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Tie-Number-Formatted>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Tie-Number-Formatted>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Tie-Number-Formatted>

=item * Search CPAN

L<http://search.cpan.org/dist/Tie-Number-Formatted/>

=back


=head1 ACKNOWLEDGEMENTS


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


