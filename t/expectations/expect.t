#!/usr/bin/env perl

use v5.14;
use warnings;

use require::relative q (test-helper.pl);

require Test::Deep;
require Test::YAFT::Expect;

testing_expectation {
	expect Test::YAFT::Expect:: (@_)
};

assume_yaft_dump q (Dumper should serialize expectation)
	=> got { expectation (42) }
	=> expect => <<'END_OF_EXPECTED'
expect Test::YAFT::Expect:: (
  42,
)
END_OF_EXPECTED
	;

check_test q (successful direct expectation)
	=> assumption {
		it q (should pass)
			=> got    => 42
			=> expect => expectation (42)
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (should pass)
	;

check_test q (failed direct expectation)
	=> assumption {
		it q (should pass)
			=> got    => 40
			=> expect => expectation (42)
			;
	}
	=> ok          => 0
	=> actual_ok   => 0
	=> name        => q (should pass)
	=> diag        => <<'EXPECTED_DIAG'
+----+-----+----+-------------------------------+
| Elt|Got  | Elt|Expected                       |
+----+-----+----+-------------------------------+
*   0|40   *   0|expect Test::YAFT::Expect:: (  *
|    |     *   1|  42,                          *
|    |     *   2|)                              *
+----+-----+----+-------------------------------+
Compared $data
   got : '40'
expect : '42'
EXPECTED_DIAG
	;

had_no_warnings;
done_testing;
