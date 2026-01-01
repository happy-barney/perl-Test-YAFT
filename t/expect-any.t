#!/usr/bin/env perl

use v5.14;
use warnings;

use require::relative q (test-helper.pl);

assume_test_yaft_exports expect_any
	=> by_default => 1
	=> on_demand  => 1
	=> by_tag     => [qw [all default expectations]]
	;

assume_yaft_dump q (Dumper should produce expect_any (1, 2))
	=> got { expect_any (1, 2) }
	=> expect => <<'END_OF_EXPECTED'
expect_any (
  1,
  2,
)
END_OF_EXPECTED
	;

check_test q (pass when first expectation matches)
	=> assumption {
		it q (should pass)
			=> got    => 5
			=> expect => expect_any (
				expect_number (5),
				expect_number (10),
			);
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (should pass)
	;

check_test q (pass when second expectation matches)
	=> assumption {
		it q (should pass)
			=> got    => 10
			=> expect => expect_any (
				expect_number (5),
				expect_number (10),
			);
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (should pass)
	;

check_test q (pass when all expectations match)
	=> assumption {
		it q (should pass)
			=> got    => 5
			=> expect => expect_any (
				expect_number (5),
				expect_number_greater_than (3),
				expect_number_less_than (10),
			);
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (should pass)
	;

check_test q (pass with string matching one expectation)
	=> assumption {
		it q (should pass)
			=> got    => q (hello)
			=> expect => expect_any (
				expect_str (q (world)),
				expect_str (q (hello)),
				expect_str (q (foo)),
			);
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (should pass)
	;

check_test q (pass with single matching expectation)
	=> assumption {
		it q (should pass)
			=> got    => 42
			=> expect => expect_any (
				expect_number (42),
			);
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (should pass)
	;

check_test q (fail when no expectations match)
	=> assumption {
		it q (should fail)
			=> got    => 5
			=> expect => expect_any (
				expect_number (10),
				expect_number (20),
			);
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
|    |     *  11|}, 'Test::Deep::Any' )          *
+----+-----+----+--------------------------------+
Comparing $data with Any
got      : '5'
expected : Any of ( 10, 20 )
END_OF_DIAG
	;

check_test q (fail with string matching no expectations)
	=> assumption {
		it q (should fail)
			=> got    => q (bar)
			=> expect => expect_any (
				expect_str (q (hello)),
				expect_str (q (world)),
				expect_str (q (foo)),
			);
	}
	=> ok          => 0
	=> actual_ok   => 0
	=> name        => q (should fail)
	=> diag        => <<'END_OF_DIAG'
+----+-------+----+--------------------------------+
| Elt|Got    | Elt|Expected                        |
+----+-------+----+--------------------------------+
*   0|'bar'  *   0|bless( {                        *
|    |       *   1|  val => [                      *
|    |       *   2|    bless( {                    *
|    |       *   3|      val => 'hello'            *
|    |       *   4|    }, 'Test::Deep::String' ),  *
|    |       *   5|    bless( {                    *
|    |       *   6|      val => 'world'            *
|    |       *   7|    }, 'Test::Deep::String' ),  *
|    |       *   8|    bless( {                    *
|    |       *   9|      val => 'foo'              *
|    |       *  10|    }, 'Test::Deep::String' )   *
|    |       *  11|  ]                             *
|    |       *  12|}, 'Test::Deep::Any' )          *
+----+-------+----+--------------------------------+
Comparing $data with Any
got      : 'bar'
expected : Any of ( 'hello', 'world', 'foo' )
END_OF_DIAG
	;

check_test q (pass with nested structure matching one option)
	=> assumption {
		it q (should pass)
			=> got    => [1, 2, 3]
			=> expect => expect_any (
				expect_array ([ 4, 5, 6]),
				expect_array ([ 1, 2, 3]),
				expect_array ([ 7, 8, 9]),
			)
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (should pass)
	;

check_test q (fail with single non-matching expectation)
	=> assumption {
		it q (should fail)
			=> got    => 5
			=> expect => expect_any (
				expect_number (10),
			);
	}
	=> ok          => 0
	=> actual_ok   => 0
	=> name        => q (should fail)
	=> diag        => <<'END_OF_DIAG'
+----+-----+----+-------------------------------+
| Elt|Got  | Elt|Expected                       |
+----+-----+----+-------------------------------+
*   0|5    *   0|bless( {                       *
|    |     *   1|  val => [                     *
|    |     *   2|    bless( {                   *
|    |     *   3|      tolerance => undef,      *
|    |     *   4|      val => 10                *
|    |     *   5|    }, 'Test::Deep::Number' )  *
|    |     *   6|  ]                            *
|    |     *   7|}, 'Test::Deep::Any' )         *
+----+-----+----+-------------------------------+
Comparing $data with Any
got      : '5'
expected : Any of ( 10 )
END_OF_DIAG
	;

had_no_warnings;
done_testing;
