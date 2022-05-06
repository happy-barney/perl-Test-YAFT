#!/usr/bin/env perl

use v5.14;
use warnings;

use require::relative "test-helper.pl";

Test::More::subtest "when getting true" => sub {
	Test::Tester::check_test
		sub {
			ok "should just pass"
				=> got    => 1
				;
		},
		{
			ok          => 1,
			actual_ok   => 1,
			name        => 'should just pass',
			diag        => '',
		}
	;
};

Test::More::subtest "when getting false" => sub {
	Test::Tester::check_test
		sub {
			ok "should just fail"
				=> got    => 0
				;
		},
		{
			ok          => 0,
			actual_ok   => 0,
			name        => 'should just fail',
			diag        => '',
		}
	;
};

Test::Warnings::had_no_warnings;

Test::More::done_testing;

