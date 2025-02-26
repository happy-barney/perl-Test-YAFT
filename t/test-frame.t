#!/usr/bin/env perl

use v5.14;
use warnings;

use require::relative q (test-helper.pl);

use Test::YAFT qw (test_frame);

sub custom_assert {
	test_frame {
		Test::More::pass q (custom-assert)
	};
}

subtest q (test_frame() should properly alter Test::Builder::Level) => sub {
	Test::Tester::check_test(
		sub { custom_assert },
		{
			ok => 1,
			name => q (custom-assert),
		},
	);
};

Test::Warnings::had_no_warnings;

had_no_warnings;

done_testing;
