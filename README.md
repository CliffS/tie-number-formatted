# NAME

Tie::Number::Formatted - Numbers that stringify formatted

# VERSION

Version 0.0.1

# SYNOPSIS

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
    



# EXPORT

Nothing is exported.

# DEPENDENCIES

Perl version 5.14.0 or higher

[Number::Format](http://search.cpan.org/perldoc?Number::Format) to do the actual formatting

[Scalar::Util](http://search.cpan.org/perldoc?Scalar::Util) for looks\_like\_number

[Carp](http://search.cpan.org/perldoc?Carp) for warnings

# SYNTAX

This ties a scalar in such a way that normal numeric operations
work on it but that it prints according to the required format.

## Tying a scalar

    tie my $number, 'Tie::Number::Formatted', @options;

## Options

- symbol

    This is the symbol for your currency.  It defaults to `"£ "`
    but can be set, for example to `"USD "` or `"$ "`.  If you don't want
    the extra space, simply set it to `"£"` or `"$"`.

- precision

    This is the number of digits after the decimal point.  If you set this
    to `0`, it will not print the decimal point.

## Beware

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
    



# AUTHOR

Cliff Stanford, `<cpan@may.be>`

# BUGS

Please report any bugs or feature requests to
`bug-tie-number-formatted at rt.cpan.org`, or through
the web interface at
[http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Tie-Number-Formatted](http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Tie-Number-Formatted).
I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

# SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Tie::Number::Formatted

# LICENSE AND COPYRIGHT

Copyright 2014 Cliff Stanford.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.
\n***\n
# NAME

Tie::Array::Formatted - An array of self-formatting numbers

# VERSION

Version 0.0.1

# SYNOPSYS

    use Tie::Array::Formatted;

    tie my @array, 'Tie::Array::Formatted';
    push @array, (100, 123, 123.456);
    print "@array\n";	# prints "£ 100.00 £ 123.00 £ 123.45"

# DEPENDENCIES

Perl version 5.14.0 or higher

[Tie::Number::Formatted](http://search.cpan.org/perldoc?Tie::Number::Formatted)

[Scalar::Util](http://search.cpan.org/perldoc?Scalar::Util) for looks\_like\_number

# SYNTAX

This ties an array so that all values
are automatically tied to Tie::Number::Formatted if they
look like numbers.  Otherwise they are simply stored as is.

## Tying an array

    tie my @array, 'Tie::Array::Formatted', @options;

## Options

For all options, see [Tie::Number::Formatted](http://search.cpan.org/perldoc?Tie::Number::Formatted).  All numbers in
the array will be formatted according to these options.

# AUTHOR

Cliff Stanford, `<cpan@may.be>`

# BUGS

Please report any bugs or feature requests to
`bug-tie-number-formatted at rt.cpan.org`, or through
the web interface at
[http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Tie-Number-Formatted](http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Tie-Number-Formatted).
I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

# SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Tie::Number::Formatted

# LICENSE AND COPYRIGHT

Copyright 2014 Cliff Stanford.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.
\n***\n

# NAME

Tie::Hash::Formatted - A hash containing self-formatting numbers

# VERSION

Version 0.0.1

# SYNOPSYS

    use Tie::Hash::Formatted;

    tie my %hash, 'Tie::Hash::Formatted';
    $hash{one} = 1;
    say $hash{one};	# prints "£ 1.00"

# DEPENDENCIES

Perl version 5.14.0 or higher

[Tie::Number::Formatted](http://search.cpan.org/perldoc?Tie::Number::Formatted)

[Scalar::Util](http://search.cpan.org/perldoc?Scalar::Util) for looks\_like\_number and blessed

# SYNTAX

This ties a hash so that the keys are normal but the values
are automatically tied to Tie::Number::Formatted if they
look like numbers.  Otherwise they are simply stored as is.

## Tying a hash

    tie my %hash, 'Tie::Hash::Formatted', @options;

## Options

For all Number options, see [Tie::Number::Formatted](http://search.cpan.org/perldoc?Tie::Number::Formatted).  All numbers in
the hash will be formatted according to these options.

There is an additional option:

- exclude

        exclude => [ qw(no_format nor_me) ]

    Exclude should be passed a pointer to an array of keys that should
    not be formatted, even if numeric values are assigned.

# AUTHOR

Cliff Stanford, `<cpan@may.be>`

# BUGS

Please report any bugs or feature requests to
`bug-tie-number-formatted at rt.cpan.org`, or through
the web interface at
[http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Tie-Number-Formatted](http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Tie-Number-Formatted).
I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

# SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Tie::Number::Formatted

# LICENSE AND COPYRIGHT

Copyright 2014 Cliff Stanford.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.
