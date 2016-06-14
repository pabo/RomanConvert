# NAME

RomanConvert - convert between roman and arabic numbers

# USAGE

    use RomanConvert;

    my $arabic = roman2arabic('XVII'); #sets $arabic to 17
    my $roman = arabic2roman(2016); #sets $roman to 'MMXVI'

# DESCRIPTION

This module will convert roman numerals to arabic, and vice versa.
It only supports the "standard" form as defined here:
[https://en.wikipedia.org/wiki/Roman\_numerals](https://en.wikipedia.org/wiki/Roman_numerals)

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

# METHODS

### roman2arabic

Accepts a string representing a roman numeral in uppercase, standard
notation.

Returns -1 for an error, or a positive value between 1 and 3999
(inclusive) with a successful conversion.

### arabic2roman

Accepts an integer between 1 and 3999 inclusive.

Returns -1 for an error, or a string containing the standard roman
numeral representation on a successful conversion.

# EXPORT

roman2arabic() and arabic2roman() are both exported by default.

# TESTING

This module includes a unit\_tests() function. Simply run it and ensure
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

# SEE ALSO

[https://github.com/pabo/RomanConvert](https://github.com/pabo/RomanConvert)

# AUTHOR

Brett Schellenberg, <brett.schellenberg@gmail.com>

# COPYRIGHT AND LICENSE
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
