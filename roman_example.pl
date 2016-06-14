#!/usr/bin/perl -w
use strict;
use RomanConvert;
# quick example usage of roman2arabic and arabic2roman

my $roman;
my $arabic;

print "Enter a roman numeral to convert to arabic: ";
$roman = <>;
chomp $roman;

$arabic = roman2arabic($roman);
if ($arabic ne -1) {
	print "$roman in arabic is $arabic\n";
}
else {
	print "could not convert $roman to arabic\n";
}

print "Enter an arabic number to convert to roman numerals: ";
$arabic = <>;
chomp $arabic;

$roman = arabic2roman($arabic);
if ($roman ne -1) {
	print "$arabic in roman numerals is $roman\n";
}
else {
	print "could not convert $arabic to roman numerals\n";
}
