#!/usr/bin/env perl

use v5.14;
use warnings;

use require::relative q (test-helper.pl);

assume_test_yaft_exports expect_number_greater_than
	=> by_default => 1
	=> on_demand  => 1
	=> by_tag     => [qw [all default expectations]]
	;

assume_yaft_dump q (Dumper should produce expect_number_greater_than (42))
	=> got { expect_number_greater_than (42) }
	=> expect => <<'END_OF_EXPECTED'
expect_number_greater_than (
  42,
)
END_OF_EXPECTED
	;

assume_yaft_dump q (Dumper should produce ! expect_number_greater_than (42))
	=> got { ! expect_number_greater_than (42) }
	=> expect => <<'END_OF_EXPECTED'
! expect_number_greater_than (
  42,
)
END_OF_EXPECTED
	;

check_test q (successful greater than comparison)
	=> assumption {
		it q (should just pass)
			=> got    => 43
			=> expect => expect_number_greater_than (42)
			;
	}
	=> ok          => 1,
	=> actual_ok   => 1,
	=> name        => q (should just pass),
	;

check_test q (failed greater than comparison with equal values)
	=> assumption {
		it q (should just fail)
			=> got    => 42
			=> expect => expect_number_greater_than (42)
			;
	}
	=> ok          => 0,
	=> actual_ok   => 0,
	=> name        => q (should just fail),
	=> diag        => <<'EXPECTED_DIAG',
+----+-----+----+------------------------------+
| Elt|Got  | Elt|Expected                      |
+----+-----+----+------------------------------+
*   0|42   *   0|expect_number_greater_than (  *
|    |     *   1|  42,                         *
|    |     *   2|)                             *
+----+-----+----+------------------------------+
Compared $data
   got : '42'
expect : > '42'
EXPECTED_DIAG
	;

check_test q (failed greater than comparison with lesser value)
	=> assumption {
		it q (should just fail)
			=> got    => 41
			=> expect => expect_number_greater_than (42)
			;
	}
	=> ok          => 0,
	=> actual_ok   => 0,
	=> name        => q (should just fail),
	=> diag        => <<'EXPECTED_DIAG',
+----+-----+----+------------------------------+
| Elt|Got  | Elt|Expected                      |
+----+-----+----+------------------------------+
*   0|41   *   0|expect_number_greater_than (  *
|    |     *   1|  42,                         *
|    |     *   2|)                             *
+----+-----+----+------------------------------+
Compared $data
   got : '41'
expect : > '42'
EXPECTED_DIAG
	;

had_no_warnings;
done_testing;
