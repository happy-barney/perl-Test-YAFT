#!/usr/bin/env perl

use v5.14;
use warnings;

use require::relative q (test-helper.pl);

check_test q (when passing expecting boolean true it should behave like 'ok')
	=> assumption {
		it q (should pass like 'ok')
			=> got    => 1
			=> expect => expect_true
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (should pass like 'ok')
	;

check_test q (when failing expecting boolean true it should behave like 'ok' (without implicit diag message))
	=> assumption {
		it q (should fail like 'ok')
			=> got    => 0
			=> expect => expect_true
			;
	}
	=> ok          => 0
	=> actual_ok   => 0
	=> name        => q (should fail like 'ok')
	;

check_test q (when passing expecting boolean false it should behave like 'nok')
	=> assumption {
		it q (should pass like 'nok')
			=> got    => 0
			=> expect => expect_false
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (should pass like 'nok')
	;

check_test q (when failing expecting boolean false it should behave like 'nok' (without implicit diag message))
	=> assumption {
		it q (should fail like 'nok')
			=> got    => 1
			=> expect => expect_false
			;
	}
	=> ok          => 0
	=> actual_ok   => 0
	=> name        => q (should fail like 'nok')
	;

check_test q (when failing with custom diag it should show it)
	=> assumption {
		it q (when failing with custom diag)
			=> got    => 1
			=> expect => expect_false
			=> diag   => q (it should not fail)
			;
	}
	=> ok          => 0
	=> actual_ok   => 0
	=> name        => q (when failing with custom diag)
	=> diag        => q (it should not fail)
	;

check_test q (when passing with Test::Deep::Cmp expectation)
	=> assumption {
		it q (pass with Test::Deep::Cmp)
			=> got    => [ 1, 2 ]
			=> expect => Test::Deep::bag (2, 1)
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (pass with Test::Deep::Cmp)
	;

check_test q (when failing with Test::Deep::Cmp expectation it should diag also using Test::Difference)
	=> assumption {
		it q (when failing with Test::Deep::Cmp)
			=> got    => [ 1, 2, 3 ]
			=> expect => Test::Deep::bag (2, 1)
			;
	}
	=> ok          => 0
	=> actual_ok   => 0
	=> name        => q (when failing with Test::Deep::Cmp)
	=> diag        => <<'EXPECTED_DIAG'
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
EXPECTED_DIAG
	;

check_test q (when failing with Test::Deep::Cmp and custom diag it should show just custom diag)
	=> assumption {
		it q (when failing with Test::Deep::Cmp)
			=> got    => [ 1, 2, 3 ]
			=> expect => Test::Deep::bag (2, 1)
			=> diag   => q (custom diag)
			;
	}
	=> ok          => 0
	=> actual_ok   => 0
	=> name        => q (when failing with Test::Deep::Cmp)
	=> diag        => q (custom diag)
	;

had_no_warnings;
done_testing;
