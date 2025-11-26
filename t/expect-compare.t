#!/usr/bin/env perl

use v5.14;
use warnings;

use require::relative q (test-helper.pl);

subtest q (successful compare with > operator) => sub {
	Test::Tester::check_test
		sub {
			it q (should just pass)
				=> got    => 43
				=> expect => expect_compare (q (>), 42)
				;
		},
		{
			ok          => 1,
			actual_ok   => 1,
			name        => q (should just pass),
			diag        => q (),
		}
	;
};

subtest q (failed compare with > operator) => sub {
	Test::Tester::check_test
		sub {
			it q (should just fail)
				=> got    => 42
				=> expect => expect_compare (q (>), 42)
				;
		},
		{
			ok          => 0,
			actual_ok   => 0,
			name        => q (should just fail),
			diag        => <<'DIAG',
+----+-----+----+---------------------------------+
| Elt|Got  | Elt|Expected                         |
+----+-----+----+---------------------------------+
*   0|42   *   0|bless( {                         *
|    |     *   1|  operator => '>',               *
|    |     *   2|  val => 42                      *
|    |     *   3|}, 'Test::YAFT::Cmp::Compare' )  *
+----+-----+----+---------------------------------+
Compared $data
   got : '42'
expect : > '42'
DIAG
		}
	;
};

had_no_warnings;

done_testing;
