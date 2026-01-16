#!/usr/bin/env perl

use v5.14;
use warnings;

use require::relative q (test-helper.pl);

assume_test_yaft_exports expect_string
	=> by_default => 1
	=> on_demand  => 1
	=> by_tag     => [qw [all default expectations]]
	;

assume_yaft_dump q (Dumper should produce expect_string ('Hello'))
	=> got { expect_string (q (Hello)) }
	=> expect => <<'END_OF_EXPECTED'
expect_string (
  'Hello',
)
END_OF_EXPECTED
	;

check_test q (pass with exact string match)
	=> assumption {
		it q (value matches expected string exactly)
			=> got    => q (Hello, World!)
			=> expect => expect_string (q (Hello, World!))
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (value matches expected string exactly)
	;

check_test q (pass with empty string)
	=> assumption {
		it q (empty string matches empty string)
			=> got    => q ()
			=> expect => expect_string (q ())
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (empty string matches empty string)
	;

check_test q (fail with different string)
	=> assumption {
		it q (value does not match expected string)
			=> got    => q (Hello)
			=> expect => expect_string (q (World))
			;
	}
	=> ok          => 0
	=> actual_ok   => 0
	=> name        => q (value does not match expected string)
	=> diag        => <<'END_OF_DIAG'
+----+---------+----+-----------------+
| Elt|Got      | Elt|Expected         |
+----+---------+----+-----------------+
*   0|'Hello'  *   0|expect_string (  *
|    |         *   1|  'World',       *
|    |         *   2|)                *
+----+---------+----+-----------------+
Comparing $data as a string
   got : 'Hello'
expect : 'World'
END_OF_DIAG
	;

check_test q (fail with case difference)
	=> assumption {
		it q (string comparison is case sensitive)
			=> got    => q (hello)
			=> expect => expect_string (q (Hello))
			;
	}
	=> ok          => 0
	=> actual_ok   => 0
	=> name        => q (string comparison is case sensitive)
	=> diag        => <<'END_OF_DIAG'
+----+---------+----+-----------------+
| Elt|Got      | Elt|Expected         |
+----+---------+----+-----------------+
*   0|'hello'  *   0|expect_string (  *
|    |         *   1|  'Hello',       *
|    |         *   2|)                *
+----+---------+----+-----------------+
Comparing $data as a string
   got : 'hello'
expect : 'Hello'
END_OF_DIAG
	;

check_test q (fail with trailing whitespace difference)
	=> assumption {
		it q (trailing whitespace matters)
			=> got    => q (Hello )
			=> expect => expect_string (q (Hello))
			;
	}
	=> ok          => 0
	=> actual_ok   => 0
	=> name        => q (trailing whitespace matters)
	=> diag        => <<'END_OF_DIAG'
+----+----------+----+-----------------+
| Elt|Got       | Elt|Expected         |
+----+----------+----+-----------------+
*   0|'Hello '  *   0|expect_string (  *
|    |          *   1|  'Hello',       *
|    |          *   2|)                *
+----+----------+----+-----------------+
Comparing $data as a string
   got : 'Hello '
expect : 'Hello'
END_OF_DIAG
	;

check_test q (expect_str is alias for expect_string)
	=> assumption {
		it q (expect_str works the same as expect_string)
			=> got    => q (Hello)
			=> expect => expect_str (q (Hello))
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (expect_str works the same as expect_string)
	;

had_no_warnings;
done_testing;
