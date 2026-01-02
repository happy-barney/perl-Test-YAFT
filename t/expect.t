#!/usr/bin/env perl

use v5.14;
use warnings;

use require::relative q (test-helper.pl);

check_test q (expect => is affected by fat comma stringification)
	=> assumption {
		it q (should just pass)
			=> expect => expect_false
			=> got    { 0 }
			;
	}
	=> ok          => 0,
	=> actual_ok   => 0,
	=> name        => q (should just pass),
	=> diag        => <<'END_OF_DIAG'
+---+-----+----------------+
| Ln|Got  |Expected        |
+---+-----+----------------+
*  1|0    |'expect_false'  *
+---+-----+----------------+
END_OF_DIAG
	;

check_test q (expect {} should execute block to get expected value)
	=> assumption {
		it q (should just pass)
			=> expect { expect_false }
			=> got    { 0 }
			;
	}
	=> ok          => 1,
	=> actual_ok   => 1,
	=> name        => q (should just pass),
	;

check_test q (expect {} block should execute block in execution context)
	=> assumption {
		arrange { foo => q (bar) };
		it q (should just pass)
			=> arrange { foo => q (foo) }
			=> expect  { arranged q (foo) }
			=> got     { q (foo) }
			;
	}
	=> ok          => 1,
	=> actual_ok   => 1,
	=> name        => q (should just pass),
	;

had_no_warnings;
done_testing;
