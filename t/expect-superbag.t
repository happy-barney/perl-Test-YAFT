#!/usr/bin/env perl

use v5.14;
use warnings;

use require::relative q (test-helper.pl);

assume_test_yaft_exports expect_superbag
	=> by_default => 1
	=> on_demand  => 1
	=> by_tag     => [qw [all default expectations]]
	;

assume_yaft_dump q (Dumper should produce expect_superbag (1, 2))
	=> got { expect_superbag (1, 2) }
	=> expect => <<'END_OF_EXPECTED'
expect_superbag (
  1,
  2,
)
END_OF_EXPECTED
	;

check_test q (pass with exact match)
	=> assumption {
		it q (should pass)
			=> got    => [ 1, 2 ]
			=> expect => expect_superbag (1, 2)
			;
	}
	=> ok          => 1,
	=> actual_ok   => 1,
	=> name        => q (should pass),
	;

check_test q (pass with different order)
	=> assumption {
		it q (should pass)
			=> got    => [ 2, 1 ]
			=> expect => expect_superbag (1, 2)
			;
	}
	=> ok          => 1,
	=> actual_ok   => 1,
	=> name        => q (should pass),
	;

check_test q (pass with extra elements)
	=> assumption {
		it q (should pass)
			=> got    => [ 2, 3, 1 ]
			=> expect => expect_superbag (1, 2)
			;
	}
	=> ok          => 1,
	=> actual_ok   => 1,
	=> name        => q (should pass),
	;

check_test q (fail with duplicate only)
	=> assumption {
		it q (should fail)
			=> got    => [ 2, 2 ]
			=> expect => expect_superbag (1, 2)
			;
	}
	=> ok          => 0,
	=> actual_ok   => 0,
	=> name        => q (should fail),
	=> diag        => <<'END_OF_DIAG'
+----+------+----+------------------------+
| Elt|Got   | Elt|Expected                |
+----+------+----+------------------------+
*   0|[     *   0|bless( {                *
*   1|  2,  *   1|  IgnoreDupes => 0,     *
*   2|  2   *   2|  SubSup => 'sup',      *
*   3|]     *   3|  val => [              *
|    |      *   4|    1,                  *
|    |      *   5|    2                   *
|    |      *   6|  ]                     *
|    |      *   7|}, 'Test::Deep::Set' )  *
+----+------+----+------------------------+
Comparing $data as a SuperBag
Missing: '1'
END_OF_DIAG
	;

check_test q (fail with missing element)
	=> assumption {
		it q (should fail)
			=> got    => [ 1 ]
			=> expect => expect_superbag (1, 2)
			;
	}
	=> ok          => 0,
	=> actual_ok   => 0,
	=> name        => q (should fail),
	=> diag        => <<'END_OF_DIAG'
+----+-----+----+------------------------+
| Elt|Got  | Elt|Expected                |
+----+-----+----+------------------------+
*   0|[    *   0|bless( {                *
*   1|  1  *   1|  IgnoreDupes => 0,     *
*   2|]    *   2|  SubSup => 'sup',      *
|    |     *   3|  val => [              *
|    |     *   4|    1,                  *
|    |     *   5|    2                   *
|    |     *   6|  ]                     *
|    |     *   7|}, 'Test::Deep::Set' )  *
+----+-----+----+------------------------+
Comparing $data as a SuperBag
Missing: '2'
END_OF_DIAG
	;

had_no_warnings;
done_testing;
