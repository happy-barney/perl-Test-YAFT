#!/usr/bin/env perl

use v5.14;
use warnings;

use require::relative q (test-helper.pl);

assume_test_yaft_exports expect_array
	=> by_default => 1
	=> on_demand  => 1
	=> by_tag     => [qw [all default expectations]]
	;

assume_yaft_dump q (Dumper should produce expect_array (1, 2, 3))
	=> got { expect_array (1, 2, 3) }
	=> expect => <<'END_OF_EXPECTED'
expect_array (
  1,
  2,
  3,
)
END_OF_EXPECTED
	;

check_test q (successful validation with empty array)
	=> assumption {
		it q (should pass with empty arrayref)
			=> got    => []
			=> expect => expect_array ()
			;
	}
	=> ok          => 1,
	=> actual_ok   => 1,
	=> name        => q (should pass with empty arrayref),
	;

check_test q (successful validation with single element)
	=> assumption {
		it q (should pass with single element)
			=> got    => [ 42 ]
			=> expect => expect_array (42)
			;
	}
	=> ok          => 1,
	=> actual_ok   => 1,
	=> name        => q (should pass with single element),
	;

check_test q (successful validation with multiple elements)
	=> assumption {
		it q (should pass with multiple elements)
			=> got    => [ 1, 2, 3 ]
			=> expect => expect_array (1, 2, 3)
			;
	}
	=> ok          => 1,
	=> actual_ok   => 1,
	=> name        => q (should pass with multiple elements),
	;

check_test q (successful validation with mixed types)
	=> assumption {
		it q (should pass with mixed types)
			=> got    => [ 42, q (foo), undef ]
			=> expect => expect_array (42, q (foo), undef)
			;
	}
	=> ok          => 1,
	=> actual_ok   => 1,
	=> name        => q (should pass with mixed types),
	;

check_test q (successful validation with nested arrays)
	=> assumption {
		it q (should pass with nested arrays)
			=> got    => [ 1, [ 2, 3 ], 4 ]
			=> expect => expect_array (1, [ 2, 3 ], 4)
			;
	}
	=> ok          => 1,
	=> actual_ok   => 1,
	=> name        => q (should pass with nested arrays),
	;

check_test q (successful validation with nested expectations)
	=> assumption {
		it q (should pass with nested expectations)
			=> got    => [ 1, [ 2, 3 ], 4 ]
			=> expect => expect_array (
				expect_number (1),
				expect_array  (2, 3),
				expect_number (4),
			)
			;
	}
	=> ok          => 1,
	=> actual_ok   => 1,
	=> name        => q (should pass with nested expectations),
	;

check_test q (successful validation with blessed arrayref)
	=> assumption {
		it q (should pass with blessed array)
			=> got    { bless [1, 2, 3], q (Blessed::Array) }
			=> expect => expect_array (1, 2, 3)
			;
	}
	=> ok          => 1,
	=> actual_ok   => 1,
	=> name        => q (should pass with blessed array),
	;

check_test q (failed validation with wrong element value)
	=> assumption {
		it q (should fail with wrong value)
			=> got    => [ 42 ]
			=> expect => expect_array (99)
			;
	}
	=> ok          => 0,
	=> actual_ok   => 0,
	=> name        => q (should fail with wrong value),
	=> diag        => <<'END_OF_DIAG'
+----+------+----+-------------------------------+
| Elt|Got   | Elt|Expected                       |
+----+------+----+-------------------------------+
*   0|[     *   0|bless( {                       *
*   1|  42  *   1|  val => [                     *
*   2|]     *   2|    99                         *
|    |      *   3|  ]                            *
|    |      *   4|}, 'Test::YAFT::Cmp::Array' )  *
+----+------+----+-------------------------------+
Compared $data->[0]
   got : '42'
expect : '99'
END_OF_DIAG
	;

check_test q (failed validation with extra elements)
	=> assumption {
		it q (should fail with extra elements)
			=> got    => [ 1, 2, 3 ]
			=> expect => expect_array (1, 2)
			;
	}
	=> ok          => 0,
	=> actual_ok   => 0,
	=> name        => q (should fail with extra elements),
	=> diag        => <<'END_OF_DIAG'
+----+------+----+-------------------------------+
| Elt|Got   | Elt|Expected                       |
+----+------+----+-------------------------------+
*   0|[     *   0|bless( {                       *
*   1|  1,  *   1|  val => [                     *
*   2|  2,  *   2|    1,                         *
*   3|  3   *   3|    2                          *
*   4|]     *   4|  ]                            *
|    |      *   5|}, 'Test::YAFT::Cmp::Array' )  *
+----+------+----+-------------------------------+
Compared array length of $data
   got : array with 3 element(s)
expect : array with 2 element(s)
END_OF_DIAG
	;

check_test q (failed validation with missing elements)
	=> assumption {
		it q (should fail with missing elements)
			=> got    => [ 1, 2 ]
			=> expect => expect_array (1, 2, 3)
			;
	}
	=> ok          => 0,
	=> actual_ok   => 0,
	=> name        => q (should fail with missing elements),
	=> diag        => <<'END_OF_DIAG'
+----+------+----+-------------------------------+
| Elt|Got   | Elt|Expected                       |
+----+------+----+-------------------------------+
*   0|[     *   0|bless( {                       *
*   1|  1,  *   1|  val => [                     *
*   2|  2   *   2|    1,                         *
*   3|]     *   3|    2,                         *
|    |      *   4|    3                          *
|    |      *   5|  ]                            *
|    |      *   6|}, 'Test::YAFT::Cmp::Array' )  *
+----+------+----+-------------------------------+
Compared array length of $data
   got : array with 2 element(s)
expect : array with 3 element(s)
END_OF_DIAG
	;

check_test q (failed validation with non-ref)
	=> assumption {
		it q (should fail with wrong type)
			=> got    => 42
			=> expect => expect_array (q (42))
			;
	}
	=> ok          => 0,
	=> actual_ok   => 0,
	=> name        => q (should fail with wrong type),
	=> diag        => <<'END_OF_DIAG'
+----+-----+----+-------------------------------+
| Elt|Got  | Elt|Expected                       |
+----+-----+----+-------------------------------+
*   0|42   *   0|bless( {                       *
|    |     *   1|  val => [                     *
|    |     *   2|    42                         *
|    |     *   3|  ]                            *
|    |     *   4|}, 'Test::YAFT::Cmp::Array' )  *
+----+-----+----+-------------------------------+
Compared reftype($data)
   got : undef
expect : 'ARRAY'
END_OF_DIAG
	;

check_test q (failed validation with non-array ref)
	=> assumption {
		it q (should fail with hashref)
			=> got    => { foo => 42 }
			=> expect => expect_array (42)
			;
	}
	=> ok          => 0,
	=> actual_ok   => 0,
	=> name        => q (should fail with hashref),
	=> diag        => <<'END_OF_DIAG'
+----+-------------+----+-------------------------------+
| Elt|Got          | Elt|Expected                       |
+----+-------------+----+-------------------------------+
*   0|{            *   0|bless( {                       *
*   1|  foo => 42  *   1|  val => [                     *
*   2|}            *   2|    42                         *
|    |             *   3|  ]                            *
|    |             *   4|}, 'Test::YAFT::Cmp::Array' )  *
+----+-------------+----+-------------------------------+
Compared reftype($data)
   got : 'HASH'
expect : 'ARRAY'
END_OF_DIAG
	;

had_no_warnings;
done_testing;
