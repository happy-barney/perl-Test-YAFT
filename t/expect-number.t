#!/usr/bin/env perl

use v5.14;
use warnings;

use require::relative q (test-helper.pl);

assume_test_yaft_exports expect_number
	=> by_default => 1
	=> on_demand  => 1
	=> by_tag     => [qw [all default expectations]]
	;

assume_yaft_dump q (Dumper should produce expect_number (42))
	=> got { expect_number (42) }
	=> expect => <<'END_OF_EXPECTED'
expect_number (
  42,
)
END_OF_EXPECTED
	;

check_test q (pass with exact numeric match)
	=> assumption {
		it q (value matches expected number exactly)
			=> got    => 42
			=> expect => expect_number (42)
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (value matches expected number exactly)
	;

check_test q (pass with numeric equivalence)
	=> assumption {
		it q (string number matches numeric value)
			=> got    => q (42)
			=> expect => expect_number (42)
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (string number matches numeric value)
	;

check_test q (pass within tolerance)
	=> assumption {
		it q (value is within tolerance range)
			=> got    => 3.142
			=> expect => expect_number (3.14159, 0.001)
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (value is within tolerance range)
	;

check_test q (pass at tolerance boundary)
	=> assumption {
		it q (value at upper tolerance boundary)
			=> got    => 42.01
			=> expect => expect_number (42, 0.01)
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (value at upper tolerance boundary)
	;

check_test q (fail with different number)
	=> assumption {
		it q (value does not match expected number)
			=> got    => 41
			=> expect => expect_number (42)
			;
	}
	=> ok          => 0
	=> actual_ok   => 0
	=> name        => q (value does not match expected number)
	=> diag        => <<'END_OF_DIAG'
+----+-----+----+-----------------+
| Elt|Got  | Elt|Expected         |
+----+-----+----+-----------------+
*   0|41   *   0|expect_number (  *
|    |     *   1|  42,            *
|    |     *   2|)                *
+----+-----+----+-----------------+
Comparing $data as a number
   got : 41
expect : 42
END_OF_DIAG
	;

check_test q (fail outside tolerance range)
	=> assumption {
		it q (value exceeds tolerance range)
			=> got    => 3.145
			=> expect => expect_number (3.14159, 0.001)
			;
	}
	=> ok          => 0
	=> actual_ok   => 0
	=> name        => q (value exceeds tolerance range)
	=> diag        => <<'END_OF_DIAG'
+----+---------+----+-----------------+
| Elt|Got      | Elt|Expected         |
+----+---------+----+-----------------+
*   0|'3.145'  *   0|expect_number (  *
|    |         *   1|  '3.14159',     *
|    |         *   2|  '0.001',       *
|    |         *   3|)                *
+----+---------+----+-----------------+
Comparing $data as a number
   got : 3.145
expect : 3.14159 +/- 0.001
END_OF_DIAG
	;

check_test q (fail with non-numeric value)
	=> assumption {
		it q (string is not a number)
			=> got    => q (not a number)
			=> expect => expect_number (42)
			;
	}
	=> ok          => 0
	=> actual_ok   => 0
	=> name        => q (string is not a number)
	=> diag        => <<'END_OF_DIAG'
+----+----------------+----+-----------------+
| Elt|Got             | Elt|Expected         |
+----+----------------+----+-----------------+
*   0|'not a number'  *   0|expect_number (  *
|    |                *   1|  42,            *
|    |                *   2|)                *
+----+----------------+----+-----------------+
Comparing $data as a number
   got : 0 ('not a number')
expect : 42
END_OF_DIAG
	;

had_no_warnings;
done_testing;
