#!/usr/bin/env perl

use v5.14;
use warnings;

use require::relative "test-helper.pl";

Test::More::subtest "when expecting boolean true" => sub {
	Test::Tester::check_test
		sub {
			it "should just pass"
				=> got    => 1
				=> expect => Test::Deep::bool (1)
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

Test::More::subtest "when expecting boolean false" => sub {
	Test::Tester::check_test
		sub {
			it "should just pass"
				=> got    => 0
				=> expect => Test::Deep::bool (0)
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

Test::More::subtest "when failing to expect boolean false" => sub {
	Test::Tester::check_test
		sub {
			it "should just pass"
				=> got    => 1
				=> expect => Test::Deep::bool (0)
				;
		},
		{
			ok          => 0,
			actual_ok   => 0,
			name        => 'should just pass',
			diag        => '',
		}
	;
};

Test::More::subtest "when failing with custom diag" => sub {
	Test::Tester::check_test
		sub {
			it "when failing with custom diag"
				=> got    => 1
				=> expect => Test::Deep::bool (0)
				=> diag   => 'it should not fail'
				;
		},
		{
			ok          => 0,
			actual_ok   => 0,
			name        => 'when failing with custom diag',
			diag        => 'it should not fail',
		},
		'when failing with custom diag'
	;
};

Test::More::subtest "when succeeding with Test::Deep::Cmp" => sub {
	Test::Tester::check_test
		sub {
			it "when succeeding with Test::Deep::Cmp"
				=> got    => [ 1, 2 ]
				=> expect => Test::Deep::bag (2, 1)
				;
		},
		{
			ok          => 1,
			actual_ok   => 1,
			name        => 'when succeeding with Test::Deep::Cmp',
			diag        => '',
		},
		'when succeeding with Test::Deep::Cmp'
	;
};

Test::More::subtest "when failing with Test::Deep::Cmp it should diag also using Test::Difference" => sub {
	Test::Tester::check_test
		sub {
			it "when failing with Test::Deep::Cmp"
				=> got    => [ 1, 2, 3 ]
				=> expect => Test::Deep::bag (2, 1)
				;
		},
		{
			ok          => 0,
			actual_ok   => 0,
			name        => 'when failing with Test::Deep::Cmp',
			diag        => <<'DIAG'
+----+------+----+------------------------+
| Elt|Got   | Elt|Expected                |
+----+------+----+------------------------+
*   0|[     *   0|bless( {                *
*   1|  1,  *   1|  IgnoreDupes => 0,     *
*   2|  2,  *   2|  SubSup => '',         *
*   3|  3   *   3|  val => [              *
*   4|]     *   4|    1,                  *
|    |      *   5|    2                   *
|    |      *   6|  ]                     *
|    |      *   7|}, 'Test::Deep::Set' )  *
+----+------+----+------------------------+
Comparing $data as a Bag
Extra: '3'
DIAG
		},
		'when failing with Test::Deep::Cmp'
	;
};

Test::More::subtest "when failing with Test::Deep::Cmp and custom diag it should diag just custom diag" => sub {
	Test::Tester::check_test
		sub {
			it "when failing with Test::Deep::Cmp"
				=> got    => [ 1, 2, 3 ]
				=> expect => Test::Deep::bag (2, 1)
				=> diag   => 'custom diag'
				;
		},
		{
			ok          => 0,
			actual_ok   => 0,
			name        => 'when failing with Test::Deep::Cmp',
			diag        => 'custom diag',
		},
		'when failing with Test::Deep::Cmp'
	;
};

Test::Warnings::had_no_warnings;

Test::More::done_testing;
