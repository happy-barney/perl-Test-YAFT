#!/usr/bin/env perl

use v5.14;
use warnings;

use require::relative q (test-helper.pl);

assume_test_yaft_exports expect_ends_with
	=> by_default => 1
	=> on_demand  => 1
	=> by_tag     => [qw [all default expectations]]
	;

assume_yaft_dump q (Dumper should produce expect_ends_with ('World'))
	=> got { expect_ends_with (q (World)) }
	=> expect => <<'END_OF_EXPECTED'
expect_ends_with (
  'World',
)
END_OF_EXPECTED
	;

check_test q (pass with exact match)
	=> assumption {
		it q (string equals suffix)
			=> got    => q (World)
			=> expect => expect_ends_with (q (World))
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (string equals suffix)
	;

check_test q (pass with string ending with suffix word)
	=> assumption {
		it q (string ends with expected suffix)
			=> got    => q (Hello, World)
			=> expect => expect_ends_with (q (World))
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (string ends with expected suffix)
	;

check_test q (pass with string ending with suffix word-part)
	=> assumption {
		it q (string ends with expected suffix)
			=> got    => q (Hello, World)
			=> expect => expect_ends_with (q (orld))
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (string ends with expected suffix)
	;

check_test q (pass with empty suffix)
	=> assumption {
		it q (any string ends with empty suffix)
			=> got    => q (Hello)
			=> expect => expect_ends_with (q ())
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (any string ends with empty suffix)
	;

check_test q (pass with undef suffix)
	=> assumption {
		it q (any string ends with undef suffix)
			=> got    => q (Hello)
			=> expect => expect_ends_with (undef)
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (any string ends with undef suffix)
	;

check_test q (pass with undef both suffix and value)
	=> assumption {
		it q (any string ends with undef both suffix and value)
			=> got    => + undef
			=> expect => expect_ends_with (undef)
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (any string ends with undef both suffix and value)
	;

check_test q (fail with different suffix)
	=> assumption {
		it q (string does not end with expected suffix)
			=> got    => q (Hello)
			=> expect => expect_ends_with (q (World))
			;
	}
	=> ok          => 0
	=> actual_ok   => 0
	=> name        => q (string does not end with expected suffix)
	=> diag        => <<'END_OF_DIAG'
+----+---------+----+--------------------+
| Elt|Got      | Elt|Expected            |
+----+---------+----+--------------------+
*   0|'Hello'  *   0|expect_ends_with (  *
|    |         *   1|  'World',          *
|    |         *   2|)                   *
+----+---------+----+--------------------+
Comparing $data as a string suffix
   got : 'Hello'
expect : a string ending with 'World'
END_OF_DIAG
	;

check_test q (fail with case difference)
	=> assumption {
		it q (suffix comparison is case sensitive)
			=> got    => q (hello, world)
			=> expect => expect_ends_with (q (World))
			;
	}
	=> ok          => 0
	=> actual_ok   => 0
	=> name        => q (suffix comparison is case sensitive)
	=> diag        => <<'END_OF_DIAG'
+----+----------------+----+--------------------+
| Elt|Got             | Elt|Expected            |
+----+----------------+----+--------------------+
*   0|'hello, world'  *   0|expect_ends_with (  *
|    |                *   1|  'World',          *
|    |                *   2|)                   *
+----+----------------+----+--------------------+
Comparing $data as a string suffix
   got : 'hello, world'
expect : a string ending with 'World'
END_OF_DIAG
	;

check_test q (fail when suffix appears earlier in string)
	=> assumption {
		it q (suffix must be at the end)
			=> got    => q (World, Hello)
			=> expect => expect_ends_with (q (World))
			;
	}
	=> ok          => 0
	=> actual_ok   => 0
	=> name        => q (suffix must be at the end)
	=> diag        => <<'END_OF_DIAG'
+----+----------------+----+--------------------+
| Elt|Got             | Elt|Expected            |
+----+----------------+----+--------------------+
*   0|'World, Hello'  *   0|expect_ends_with (  *
|    |                *   1|  'World',          *
|    |                *   2|)                   *
+----+----------------+----+--------------------+
Comparing $data as a string suffix
   got : 'World, Hello'
expect : a string ending with 'World'
END_OF_DIAG
	;

check_test q (fail with undef `got` value)
	=> assumption {
		it q (undef does not end with any suffix)
			=> got    { undef }
			=> expect => expect_ends_with (q (World))
			;
	}
	=> ok          => 0
	=> actual_ok   => 0
	=> name        => q (undef does not end with any suffix)
	=> diag        => <<'END_OF_DIAG'
+----+-------+----+--------------------+
| Elt|Got    | Elt|Expected            |
+----+-------+----+--------------------+
*   0|undef  *   0|expect_ends_with (  *
|    |       *   1|  'World',          *
|    |       *   2|)                   *
+----+-------+----+--------------------+
Comparing $data as a string suffix
   got : undef
expect : a string ending with 'World'
END_OF_DIAG
	;

had_no_warnings;
done_testing;
