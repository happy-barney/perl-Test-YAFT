#!/usr/bin/env perl

use v5.14;
use warnings;

use require::relative q (test-helper.pl);

assume_test_yaft_exports expect_starts_with
	=> by_default => 1
	=> on_demand  => 1
	=> by_tag     => [qw [all default expectations]]
	;

assume_yaft_dump q (Dumper should produce expect_starts_with ('Hello'))
	=> got { expect_starts_with (q (Hello)) }
	=> expect => <<'END_OF_EXPECTED'
expect_starts_with (
  'Hello',
)
END_OF_EXPECTED
	;

check_test q (pass with exact match)
	=> assumption {
		it q (string equals prefix)
			=> got    => q (Hello)
			=> expect => expect_starts_with (q (Hello))
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (string equals prefix)
	;

check_test q (pass with string starting with prefix word)
	=> assumption {
		it q (string starts with expected prefix)
			=> got    => q (Hello, World!)
			=> expect => expect_starts_with (q (Hello))
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (string starts with expected prefix)
	;

check_test q (pass with string starting with prefix word-part)
	=> assumption {
		it q (string starts with expected prefix)
			=> got    => q (Hello, World!)
			=> expect => expect_starts_with (q (Hell))
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (string starts with expected prefix)
	;

check_test q (pass with empty prefix)
	=> assumption {
		it q (any string starts with empty prefix)
			=> got    => q (Hello)
			=> expect => expect_starts_with (q ())
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (any string starts with empty prefix)
	;

check_test q (pass with undef prefix)
	=> assumption {
		it q (any string starts with undef prefix)
			=> got    => q (Hello)
			=> expect => expect_starts_with (undef)
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (any string starts with undef prefix)
	;

check_test q (pass with undef both prefix and value)
	=> assumption {
		it q (any string starts with undef both prefix and value)
			=> got    => + undef
			=> expect => expect_starts_with (undef)
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (any string starts with undef both prefix and value)
	;

check_test q (fail with different prefix)
	=> assumption {
		it q (string does not start with expected prefix)
			=> got    => q (Hello)
			=> expect => expect_starts_with (q (World))
			;
	}
	=> ok          => 0
	=> actual_ok   => 0
	=> name        => q (string does not start with expected prefix)
	=> diag        => <<'END_OF_DIAG'
+----+---------+----+----------------------+
| Elt|Got      | Elt|Expected              |
+----+---------+----+----------------------+
*   0|'Hello'  *   0|expect_starts_with (  *
|    |         *   1|  'World',            *
|    |         *   2|)                     *
+----+---------+----+----------------------+
Comparing $data as a string prefix
   got : 'Hello'
expect : a string starting with 'World'
END_OF_DIAG
	;

check_test q (fail with case difference)
	=> assumption {
		it q (prefix comparison is case sensitive)
			=> got    => q (hello, world!)
			=> expect => expect_starts_with (q (Hello))
			;
	}
	=> ok          => 0
	=> actual_ok   => 0
	=> name        => q (prefix comparison is case sensitive)
	=> diag        => <<'END_OF_DIAG'
+----+-----------------+----+----------------------+
| Elt|Got              | Elt|Expected              |
+----+-----------------+----+----------------------+
*   0|'hello, world!'  *   0|expect_starts_with (  *
|    |                 *   1|  'Hello',            *
|    |                 *   2|)                     *
+----+-----------------+----+----------------------+
Comparing $data as a string prefix
   got : 'hello, world!'
expect : a string starting with 'Hello'
END_OF_DIAG
	;

check_test q (fail when prefix appears later in string)
	=> assumption {
		it q (prefix must be at the start)
			=> got    => q (Say Hello)
			=> expect => expect_starts_with (q (Hello))
			;
	}
	=> ok          => 0
	=> actual_ok   => 0
	=> name        => q (prefix must be at the start)
	=> diag        => <<'END_OF_DIAG'
+----+-------------+----+----------------------+
| Elt|Got          | Elt|Expected              |
+----+-------------+----+----------------------+
*   0|'Say Hello'  *   0|expect_starts_with (  *
|    |             *   1|  'Hello',            *
|    |             *   2|)                     *
+----+-------------+----+----------------------+
Comparing $data as a string prefix
   got : 'Say Hello'
expect : a string starting with 'Hello'
END_OF_DIAG
	;

check_test q (fail with undef `got` value)
	=> assumption {
		it q (undef does not start with any prefix)
			=> got    { undef }
			=> expect => expect_starts_with (q (Hello))
			;
	}
	=> ok          => 0
	=> actual_ok   => 0
	=> name        => q (undef does not start with any prefix)
	=> diag        => <<'END_OF_DIAG'
+----+-------+----+----------------------+
| Elt|Got    | Elt|Expected              |
+----+-------+----+----------------------+
*   0|undef  *   0|expect_starts_with (  *
|    |       *   1|  'Hello',            *
|    |       *   2|)                     *
+----+-------+----+----------------------+
Comparing $data as a string prefix
   got : undef
expect : a string starting with 'Hello'
END_OF_DIAG
	;

had_no_warnings;
done_testing;
