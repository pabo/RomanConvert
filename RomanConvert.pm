package RomanConvert;

=head1 NAME

RomanConvert - convert between roman and arabic numbers

=head1 USAGE

  use RomanConvert;

  my $arabic = roman2arabic('XVII'); #sets $arabic to 17
  my $roman = arabic2roman(2016); #sets $roman to 'MMXVI'

=head1 DESCRIPTION

This module will convert roman numerals to arabic, and vice versa.
It only supports the "standard" form as defined here:
L<https://en.wikipedia.org/wiki/Roman_numerals>

This is to say that it supports arabic numbers 0-3999 and roman
numerals with symbols of decreasing value, with the exception of
certain subtraction-based symbols: CM, CD, XC, XL, IX, and IV.
Alternate forms containing non-standard subtraction-based symbols
like IIX for 8 are unsupported.

Additionally each symbol may not appear more than 3 times
consecutively. This is why we cannot represent 4000 or higher,
since that would start with MMMM.

Finally, each subtraction-based symbol may only appear once.

Some other forms which might be legal according to the above rules,
like IXV for 14, are non-standard because there is a standard way
to represent them. In this case, 14 is XIV.

There is exactly one standard way to represent each arabic number
with roman numerals. This way is defined by arabic2roman.
Therefore when we are tying to parse a roman numeral into arabic,
we can do the reverse lookup with the result to verify that the
roman numeral passed in was of the correct form.

=head1 METHODS

=head3 roman2arabic

Accepts a string representing a roman numeral in uppercase, standard
notation.

Returns -1 for an error, or a positive value between 1 and 3999
(inclusive) with a successful conversion.

=head3 arabic2roman

Accepts an integer between 1 and 3999 inclusive.

Returns -1 for an error, or a string containing the standard roman
numeral representation on a successful conversion.

=head1 EXPORT

roman2arabic() and arabic2roman() are both exported by default.

=head1 TESTING

This module includes a unit_tests() function. Simply run it and ensure
all tests pass, with no FAILED tests:

    use RomanConvert;

    RomanConvert::unit_tests();

example (truncated) output:

    roman2arabic(arabic2roman(1..3999))...passed
    sub arabic2roman...
    1 = I.................................passed
    16 = XVI..............................passed
    sub roman2arabic...
    V = 5.................................passed
    MMII = 2002...........................passed

=head1 SEE ALSO

L<https://github.com/pabo/RomanConvert>

=head1 AUTHOR

Brett Schellenberg, <brett.schellenberg@gmail.com>

=head1 COPYRIGHT AND LICENSE
Copyright (c) 2016 Brett Schellenberg

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

=cut

use Exporter qw( import );
our @EXPORT = qw(
	roman2arabic
	arabic2roman
);

# These are the valid roman numeral symbols and their arabic value equivalentes,
# in decreasing order.
my @rules = (
	{ roman => 'M',  arabic => '1000' },
	{ roman => 'CM', arabic => '900' },
	{ roman => 'D',  arabic => '500' },
	{ roman => 'CD', arabic => '400' },
	{ roman => 'C',  arabic => '100' },
	{ roman => 'XC', arabic => '90' },
	{ roman => 'L',  arabic => '50' },
	{ roman => 'XL', arabic => '40' },
	{ roman => 'X',  arabic => '10' },
	{ roman => 'IX', arabic => '9' },
	{ roman => 'V',  arabic => '5' },
	{ roman => 'IV', arabic => '4' },
	{ roman => 'I',  arabic => '1' },
);

sub roman2arabic {
	my $roman = $_[0];
	my $roman_original = $roman;
	my $arabic = 0;

	foreach my $rule (@rules) {
		my $count = 0;

		# if this roman symbol is 2 characters long, it is a subtraction-based one,
		# and may only appear once. Otherwise, it may appear up to three times.
		my $maxcount = (length $rule->{roman} == 2) ? 1: 3;

		# shave off roman symbols from the beginning, and increase the arabic value
		# by the appropriate amount. we do this in decending order of the @rules so
		# that we treat IV as 4 instead of treating it as a 1 followed by a 5.
		while (++$count <= $maxcount && $roman =~ s/^$rule->{roman}//) {
			$arabic += $rule->{arabic};
		}
	}

	# ensure we parsed the whole string and that the roman value passed in was in
	# standard form. This last check prevents things like IXV from being converted
	# to 14, since the standard way of representing 14 is XIV
	if ($roman eq '' && $roman_original eq arabic2roman($arabic)) {
		return $arabic;
	}
	else {
		return -1;
	}
}

sub arabic2roman {
	my $arabic = $_[0];
	my $roman = '';

	# early exit if the input is out of allowed bounds
	return -1 unless $arabic > 0 && $arabic < 4000;

	# Starting with M = 1000, and decreasing through the roman numerals to I = 1,
	# take away chunks of the arabic number and append their roman equivalent
	foreach my $rule (@rules) {
		while ($arabic >= $rule->{arabic}) {
			$arabic -= $rule->{arabic};
			$roman .= $rule->{roman};
		}
	}

	# ensure we stepped all the way down to zero and so have a valid conversion
	if ($arabic == 0) {
		return $roman;
	}
	else {
		return -1;
	}
}

sub unit_tests {
	# this first test makes sure that arabic2roman and roman2arabic are inverse
	# functions over the full accepted range (1 to 3999)
	my $failed = 0;
	print "roman2arabic(arabic2roman(1..3999))...";
	foreach my $i (1..3999) {
		if (! roman2arabic(arabic2roman($i)) == $i) {
			print "FAILED\n";
			$failed = 1;
			last;
		}
	}
	print "passed\n" unless ($failed);

	# the rest of the tests are edge cases and sanity checks
	print "sub arabic2roman...\n";
	print "1 = I.................................", (arabic2roman(1) eq 'I') ? "passed\n" : "FAILED\n";
	print "16 = XVI..............................", (arabic2roman(16) eq 'XVI') ? "passed\n" : "FAILED\n";
	print "1980 = MCMLXXX........................", (arabic2roman(1980) eq 'MCMLXXX') ? "passed\n" : "FAILED\n";
	print "-500 = error..........................", (arabic2roman(-500) eq '-1') ? "passed\n" : "FAILED\n";
	print "0 = error.............................", (arabic2roman(0) eq '-1') ? "passed\n" : "FAILED\n";
	print "4000 = error..........................", (arabic2roman(4000) eq '-1') ? "passed\n" : "FAILED\n";
	print "99999999 = error......................", (arabic2roman(99999999) eq '-1') ? "passed\n" : "FAILED\n";

	print "sub roman2arabic...\n";
	print "V = 5.................................", (roman2arabic('V') eq 5) ? "passed\n" : "FAILED\n";
	print "MMII = 2002...........................", (roman2arabic('MMII') eq 2002) ? "passed\n" : "FAILED\n";
	print "IIII = error..........................", (roman2arabic('IIII') eq -1) ? "passed\n" : "FAILED\n";
	print "IXIX = error..........................", (roman2arabic('IXIX') eq -1) ? "passed\n" : "FAILED\n";
	print "G = error.............................", (roman2arabic('G') eq -1) ? "passed\n" : "FAILED\n";
	print "10 = error............................", (roman2arabic('10') eq -1) ? "passed\n" : "FAILED\n";
	print "IXV = error...........................", (roman2arabic('IXV') eq -1) ? "passed\n" : "FAILED\n";

}

1;
