#!/usr/bin/env perl

use v5.14;
use warnings;

use require::relative q (test-helper.pl);

assume_test_yaft_exports expect_all
	=> by_default => 1
	=> on_demand  => 1
	=> by_tag     => [qw [all default expectations]]
	;

assume_yaft_dump q (Dumper should produce expect_all (1, 2))
	=> got { expect_all (1, 2) }
	=> expect => <<'END_OF_EXPECTED'
expect_all (
  1,
  2,
)
END_OF_EXPECTED
	;

check_test q (pass when all expectations match)
	=> assumption {
		it q (should pass)
			=> got    => 5
			=> expect => expect_all (
				expect_number (5),
				expect_number_greater_than (3),
				expect_number_less_than (10),
			);
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (should pass)
	;

check_test q (pass when all string expectations match)
	=> assumption {
		it q (should pass)
			=> got    => q (hello)
			=> expect => expect_all (
				expect_str (q (hello)),
				expect_like (qr (^h)),
				expect_like (qr (o$)),
			);
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (should pass)
	;

check_test q (pass with single expectation)
	=> assumption {
		it q (should pass)
			=> got    => 42
			=> expect => expect_all (
				expect_number (42),
			);
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (should pass)
	;

check_test q (fail when one expectation fails)
	=> assumption {
		it q (should fail)
			=> got    => 5
			=> expect => expect_all (
				expect_number (5),
				expect_number_greater_than (10),
			);
	}
	=> ok          => 0
	=> actual_ok   => 0
	=> name        => q (should fail)
	=> diag        => <<'END_OF_DIAG'
+----+-----+----+-------------------------------------+
| Elt|Got  | Elt|Expected                             |
+----+-----+----+-------------------------------------+
*   0|5    *   0|bless( {                             *
|    |     *   1|  val => [                           *
|    |     *   2|    bless( {                         *
|    |     *   3|      tolerance => undef,            *
|    |     *   4|      val => 5                       *
|    |     *   5|    }, 'Test::Deep::Number' ),       *
|    |     *   6|    bless( {                         *
|    |     *   7|      operator => '>',               *
|    |     *   8|      val => 10                      *
|    |     *   9|    }, 'Test::YAFT::Cmp::Compare' )  *
|    |     *  10|  ]                                  *
|    |     *  11|}, 'Test::Deep::All' )               *
+----+-----+----+-------------------------------------+
Compared (Part 2 of 2 in $data)
   got : '5'
expect : > '10'
END_OF_DIAG
	;

check_test q (fail when all expectations fail)
	=> assumption {
		it q (should fail)
			=> got    => 5
			=> expect => expect_all (
				expect_number (10),
				expect_number (20),
			)
			;
	}
	=> ok          => 0
	=> actual_ok   => 0
	=> name        => q (should fail)
	=> diag        => <<'END_OF_DIAG'
+----+-----+----+--------------------------------+
| Elt|Got  | Elt|Expected                        |
+----+-----+----+--------------------------------+
*   0|5    *   0|bless( {                        *
|    |     *   1|  val => [                      *
|    |     *   2|    bless( {                    *
|    |     *   3|      tolerance => undef,       *
|    |     *   4|      val => 10                 *
|    |     *   5|    }, 'Test::Deep::Number' ),  *
|    |     *   6|    bless( {                    *
|    |     *   7|      tolerance => undef,       *
|    |     *   8|      val => 20                 *
|    |     *   9|    }, 'Test::Deep::Number' )   *
|    |     *  10|  ]                             *
|    |     *  11|}, 'Test::Deep::All' )          *
+----+-----+----+--------------------------------+
Comparing (Part 1 of 2 in $data) as a number
   got : 5
expect : 10
END_OF_DIAG
	;

check_test q (pass with nested structure)
	=> assumption {
		it q (should pass)
			=> got    => [ 1, 2, 3 ]
			=> expect => expect_all (
				expect_array ([ 1, 2, 3 ]),
				expect_array_length (3),
			)
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (should pass)
	;

had_no_warnings;
done_testing;
