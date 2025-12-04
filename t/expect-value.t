#!/usr/bin/env perl

use v5.14;
use warnings;

use require::relative q (test-helper.pl);

check_test q (expecting value)
	=> assumption {
		it q (should just pass)
			=> got    => 42
			=> expect => expect_value (42)
			;
	},
	=> ok          => 1,
	=> actual_ok   => 1,
	=> name        => q (should just pass),
	;

check_test q (failing to expect value)
	=> assumption {
		it q (should just pass)
			=> got    => 1
			=> expect => 42
			;
	}
	=> ok          => 0,
	=> actual_ok   => 0,
	=> name        => q (should just pass),
	=> diag        => <<'EXPECTED_DIAG'
+---+-----+----------+
| Ln|Got  |Expected  |
+---+-----+----------+
*  1|1    |42        *
+---+-----+----------+
EXPECTED_DIAG
	;

had_no_warnings;
done_testing;
