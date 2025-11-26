#!/usr/bin/env perl

use v5.14;
use warnings;

use require::relative q (test-helper.pl);

subtest q (when getting true) => sub {
	Test::Tester::check_test
		sub {
			ok q (should just pass)
				=> got    => 1
				;
		},
		{
			ok          => 1,
			actual_ok   => 1,
			name        => q (should just pass),
			diag        => q (),
		}
	;
};

subtest q (when getting false) => sub {
	Test::Tester::check_test
		sub {
			ok q (should just fail)
				=> got    => 0
				;
		},
		{
			ok          => 0,
			actual_ok   => 0,
			name        => q (should just fail),
			diag        => q (),
		}
	;
};

had_no_warnings;

done_testing;

