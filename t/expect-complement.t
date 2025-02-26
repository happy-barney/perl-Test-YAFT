#!/usr/bin/env perl

use v5.14;
use warnings;

use require::relative q (test-helper.pl);

subtest q (should expect different value) => sub {
	Test::Tester::check_test
		sub {
			it q (should just pass)
				=> got    => 24
				=> expect => expect_complement (42)
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

subtest q (success expectation of something else than boolean true) => sub {
	Test::Tester::check_test
		sub {
			it q (should just pass)
				=> got    => 0
				=> expect => ! expect_true
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

subtest q (failed expectation of something else than boolean true) => sub {
	Test::Tester::check_test
		sub {
			it q (should just fail)
				=> got    => 0
				=> expect => ! expect_false
				;
		},
		{
			ok          => 0,
			actual_ok   => 0,
			name        => q (should just fail),
			diag        => <<'DIAG'
Compared $data
   got : '0'
expect : Different value than: false ('0')
DIAG
		}
	;
};

had_no_warnings;

done_testing;
