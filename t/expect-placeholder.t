#!/usr/bin/env perl

use v5.14;
use warnings;

use require::relative q (test-helper.pl);

use Test::YAFT::Cmp::Placeholder;

check_test q (first evaluation should always pass)
	=> assumption {
		it q (should pass)
			=> got    => 42
			=> expect => expect_placeholder (q (x))
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (should pass)
	;

check_test q (should pass when subsequent evaluation matches)
	=> assumption {
		it q (should pass)
			=> got    => [ 42, { foo => 42 } ]
			=> expect => [
				expect_placeholder (q (x)),
				{ foo => expect_placeholder (q (x)) },
			];
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (should pass)
	;

check_test q (should fail when subsequent evaluation in same context doesn't match)
	=> assumption {
		Test::YAFT::eq_deeply 99, expect_placeholder (q (x));

		it q (should fail)
			=> got    => 42
			=> expect => expect_placeholder (q (x))
			;
	}
	=> ok          => 0
	=> actual_ok   => 0
	=> name        => q (should fail)
	=> diag        => <<'END_OF_DIAG'
+----+-----+----+-------------------------------------+
| Elt|Got  | Elt|Expected                             |
+----+-----+----+-------------------------------------+
*   0|42   *   0|bless( {                             *
|    |     *   1|  _expectation => undef,             *
|    |     *   2|  _name => 'x',                      *
|    |     *   3|  _singleton => 'placeholder:x',     *
|    |     *   4|  val => 99                          *
|    |     *   5|}, 'Test::YAFT::Cmp::Placeholder' )  *
+----+-----+----+-------------------------------------+
Compared $data
   got : '42'
expect : '99'
END_OF_DIAG
	;

check_test q (should pass first evaluation when value matches expectation)
	=> assumption {
		it q (should pass)
			=> got    => 42
			=> expect => expect_placeholder (q (x), expect_num (42))
			;
	}
	=> ok          => 1,
	=> actual_ok   => 1,
	=> name        => q (should pass),
	;

check_test q (should fail first evaluation when value does not match expectation)
	=> assumption {
		it q (should fail)
			=> got    => 42
			=> expect => expect_placeholder (q (x), expect_num (99))
			;
	}
	=> ok          => 0,
	=> actual_ok   => 0,
	=> name        => q (should fail),
	=> diag        => <<'END_OF_DIAG'
+----+-----+----+-------------------------------------+
| Elt|Got  | Elt|Expected                             |
+----+-----+----+-------------------------------------+
*   0|42   *   0|bless( {                             *
|    |     *   1|  _expectation => bless( {           *
|    |     *   2|    tolerance => undef,              *
|    |     *   3|    val => 99                        *
|    |     *   4|  }, 'Test::Deep::Number' ),         *
|    |     *   5|  _name => 'x',                      *
|    |     *   6|  _singleton => 'placeholder:x'      *
|    |     *   7|}, 'Test::YAFT::Cmp::Placeholder' )  *
+----+-----+----+-------------------------------------+
Comparing $data as a number
   got : 42
expect : 99
END_OF_DIAG
	;

check_test q (subsequent evaluation should not evaluate initial expectation)
	=> assumption {
		it q (should pass)
			=> got    => [ 42, 42 ]
			=> expect => [
				expect_placeholder (q (x), expect_num (42)),
				expect_placeholder (q (x), expect_num (99)),
			];
	}
	=> ok          => 1,
	=> actual_ok   => 1,
	=> name        => q (should pass),
	;

check_test q (there can be multiple placeholders with different names)
	=> assumption {
		it q (should pass)
			=> got    => [ 42, 99 ]
			=> expect => [
				expect_placeholder (q (alpha), expect_num (42)),
				expect_placeholder (q (gamma), expect_num (99)),
			];
	}
	=> ok          => 1,
	=> actual_ok   => 1,
	=> name        => q (should pass),
	;

had_no_warnings;
done_testing;
