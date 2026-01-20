#!/usr/bin/env perl

use v5.14;
use warnings;

use require::relative q (test-helper.pl);

check_test q (expect_like () should match `$got` with provided regex)
	=> assumption {
		it q (should just pass)
			=> got    => q (foo)
			=> expect => expect_like (qr (oo))
			;
	}
	=> ok          => 1,
	=> actual_ok   => 1,
	=> name        => q (should just pass),
	;


check_test q (pass with simple regex match)
	=> assumption {
		it q (string matches regex)
			=> got    => q (Hello, World!)
			=> expect => expect_like (qr (World))
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (string matches regex)
	;

check_test q (pass with regex at start)
	=> assumption {
		it q (string starts with pattern)
			=> got    => q (Hello, World!)
			=> expect => expect_like (qr (^Hello))
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (string starts with pattern)
	;

check_test q (pass with regex at end)
	=> assumption {
		it q (string ends with pattern)
			=> got    => q (Hello, World!)
			=> expect => expect_like (qr (World!$))
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (string ends with pattern)
	;

check_test q (pass with case insensitive regex)
	=> assumption {
		it q (case insensitive match)
			=> got    => q (HELLO)
			=> expect => expect_like (qr (hello)i)
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (case insensitive match)
	;

check_test q (pass with extended regex)
	=> assumption {
		it q (extended regex with whitespace)
			=> got    => q (foo@bar.com)
			=> expect => expect_like (qr (^ \w+ @ \w+ [.] \w+ $)x)
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (extended regex with whitespace)
	;

check_test q (fail with no match)
	=> assumption {
		it q (string does not match regex)
			=> got    => q (Hello)
			=> expect => expect_like (qr (World))
			;
	}
	=> ok          => 0
	=> actual_ok   => 0
	=> name        => q (string does not match regex)
	=> diag        => <<'EXPECTED_DIAG'
+----+---------+----+---------------+
| Elt|Got      | Elt|Expected       |
+----+---------+----+---------------+
*   0|'Hello'  *   0|expect_like (  *
|    |         *   1|  qr/World/u,  *
|    |         *   2|)              *
+----+---------+----+---------------+
Using Regexp on $data
   got : 'Hello'
expect : (?^u:World)
EXPECTED_DIAG
	;

check_test q (fail with case difference)
	=> assumption {
		it q (regex is case sensitive by default)
			=> got    => q (hello)
			=> expect => expect_like (qr (Hello))
			;
	}
	=> ok          => 0
	=> actual_ok   => 0
	=> name        => q (regex is case sensitive by default)
	=> diag        => <<'EXPECTED_DIAG'
+----+---------+----+---------------+
| Elt|Got      | Elt|Expected       |
+----+---------+----+---------------+
*   0|'hello'  *   0|expect_like (  *
|    |         *   1|  qr/Hello/u,  *
|    |         *   2|)              *
+----+---------+----+---------------+
Using Regexp on $data
   got : 'hello'
expect : (?^u:Hello)
EXPECTED_DIAG
	;

check_test q (fail when pattern not at expected position)
	=> assumption {
		it q (pattern must be at start when anchored)
			=> got    => q (Say Hello)
			=> expect => expect_like (qr (^Hello))
			;
	}
	=> ok          => 0
	=> actual_ok   => 0
	=> name        => q (pattern must be at start when anchored)
	=> diag        => <<'EXPECTED_DIAG'
+----+-------------+----+----------------+
| Elt|Got          | Elt|Expected        |
+----+-------------+----+----------------+
*   0|'Say Hello'  *   0|expect_like (   *
|    |             *   1|  qr/^Hello/u,  *
|    |             *   2|)               *
+----+-------------+----+----------------+
Using Regexp on $data
   got : 'Say Hello'
expect : (?^u:^Hello)
EXPECTED_DIAG
	;

had_no_warnings;
done_testing;
