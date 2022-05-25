
use v5.14;
use warnings;

use Test::Tester import => [qw[ !check_test ]];
use Test::Deep qw[];
use Test::More qw[];
use Test::Warnings qw[ :no_end_test ];

use Test::YAFT;

sub check_test (&;@) {
	my ($code, %expectations) = @_;

	Test::Tester::check_test $code, \%expectations;
}

1;
