#!/usr/bin/env perl

use v5.14;
use warnings;

use require::relative q (test-helper.pl);

subtest q (when just fails) => sub {
	Test::Tester::check_test
		sub {
			fail q (when just fails);
		},
		{
			ok          => 0,
			actual_ok   => 0,
			name        => q (when just fails),
			diag        => q (),
		},
		q (when just fails)
	;
};

subtest q (when failing with custom diag) => sub {
	Test::Tester::check_test
		sub {
			fail q (when failing with custom diag)
				=> diag   => q (custom diag)
				;
		},
		{
			ok          => 0,
			actual_ok   => 0,
			name        => q (when failing with custom diag),
			diag        => q (custom diag),
		},
		q (when failing with custom diag)
	;
};

had_no_warnings;

Test::More::done_testing;
