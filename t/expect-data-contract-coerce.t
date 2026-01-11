#!/usr/bin/env perl

use v5.14;
use warnings;

use require::relative q (test-helper.pl);

assume_test_yaft_exports expect_data_contract
	=> by_default => 1
	=> on_demand  => 1
	=> by_tag     => [qw [all default expectations]]
	;

SKIP: {
	eval { require Type::Tiny; 1 }
		or skip q (Type::Tiny not available), 2
		;

	require Types::Standard;

	my $Coercible_Int = Types::Standard::Int ()
		->plus_coercions (
			Types::Standard::Str () => sub { length }
		);

	subtest q (Type::Tiny - with coercion) => sub {
		check_test q (successful validation without coercion needed)
			=> assumption {
				it q (should pass without coercion)
					=> got    => 42
					=> expect => expect_data_contract_coerce ($Coercible_Int)
					;
			}
			=> ok          => 1
			=> actual_ok   => 1
			=> name        => q (should pass without coercion)
			;

		check_test q (successful validation with coercion)
			=> assumption {
				it q (should pass with coercion)
					=> got    => q (not a number)
					=> expect => expect_data_contract_coerce ($Coercible_Int)
					;
			}
			=> ok          => 1
			=> actual_ok   => 1
			=> name        => q (should pass with coercion)
			;

		check_test q (failed validaton (incoercible))
			=> assumption {
				it q (should fail with incoercible value)
					=> got    => []
					=> expect => expect_data_contract_coerce ($Coercible_Int)
					;
			}
			=> ok          => 0
			=> actual_ok   => 0
			=> name        => q (should fail with incoercible value)
			=> diag        => <<'END_OF_DIAG'
+----+-----+----+-------------------------------+
| Elt|Got  | Elt|Expected                       |
+----+-----+----+-------------------------------+
*   0|[]   *   0|expect_data_contract_coerce (  *
|    |     *   1|  Int,                         *
|    |     *   2|)                              *
+----+-----+----+-------------------------------+
Compared $data
   got : ARRAY(0x...)
expect : Type::Tiny contract Int (coerced)
END_OF_DIAG
			;
	};

	subtest q (Type::Tiny - without coercion) => sub {
		check_test q (successful validation)
			=> assumption {
				it q (should validate without coercion)
					=> got    => 42
					=> expect => expect_data_contract_coerce (Types::Standard::Int ())
					;
			}
			=> ok          => 1
			=> actual_ok   => 1
			=> name        => q (should validate without coercion)
			;

		check_test q (failed validation (incoercible))
			=> assumption {
				it q (should fail without coercion)
					=> got    => q (not a number)
				=> expect => expect_data_contract_coerce (Types::Standard::Int ())
				;
			}
			=> ok          => 0
			=> actual_ok   => 0
			=> name        => q (should fail without coercion)
			=> diag        => <<'END_OF_DIAG'
+----+----------------+----+-------------------------------+
| Elt|Got             | Elt|Expected                       |
+----+----------------+----+-------------------------------+
*   0|'not a number'  *   0|expect_data_contract_coerce (  *
|    |                *   1|  Int,                         *
|    |                *   2|)                              *
+----+----------------+----+-------------------------------+
Compared $data
   got : 'not a number'
expect : Type::Tiny contract Int (coerced)
END_OF_DIAG
			;
	};
}

SKIP: {
	eval { require Moose::Util::TypeConstraints; 1 }
		or skip q (Moose not available), 2
		;

	package Moose::Coercible {
		use Moose::Util::TypeConstraints;

		subtype Coercible_Int
			=> as q (Int)
			;

		coerce Coercible_Int
			=> from Str
			=> via { length }
			;
	}

	subtest q (Moose - with coercion) => sub {
		check_test q (successful validation without coercion needed)
			=> assumption {
				it q (should pass without coercion)
					=> got    => 42
					=> expect => expect_data_contract_coerce (q (Coercible_Int))
					;
			}
			=> ok          => 1
			=> actual_ok   => 1
			=> name        => q (should pass without coercion)
			;

		check_test q (successful validation with coercion)
			=> assumption {
				it q (should pass with coercion)
					=> got    => q (not a number)
					=> expect => expect_data_contract_coerce (q (Coercible_Int))
					;
			}
			=> ok          => 1
			=> actual_ok   => 1
			=> name        => q (should pass with coercion)
			;

		check_test q (failed validaton (incoercible))
			=> assumption {
				it q (should fail with incoercible value)
					=> got    => []
					=> expect => expect_data_contract_coerce (q (Coercible_Int))
					;
			}
			=> ok          => 0
			=> actual_ok   => 0
			=> name        => q (should fail with incoercible value)
			=> diag        => <<'END_OF_DIAG'
+----+-----+----+-------------------------------+
| Elt|Got  | Elt|Expected                       |
+----+-----+----+-------------------------------+
*   0|[]   *   0|expect_data_contract_coerce (  *
|    |     *   1|  'Coercible_Int',             *
|    |     *   2|)                              *
+----+-----+----+-------------------------------+
Compared $data
   got : ARRAY(0x...)
expect : Moose contract Coercible_Int (coerced)
END_OF_DIAG
			;
	};

	subtest q (Moose - without coercion) => sub {
		check_test q (successful validation)
			=> assumption {
				it q (should validate without coercion)
					=> got    => 42
					=> expect => expect_data_contract_coerce (q (Int))
					;
			}
			=> ok          => 1
			=> actual_ok   => 1
			=> name        => q (should validate without coercion)
			;

		check_test q (failed validation (incoercible))
			=> assumption {
				it q (should fail without coercion)
					=> got    => q (not a number)
				=> expect => expect_data_contract_coerce (q (Int))
				;
			}
			=> ok          => 0
			=> actual_ok   => 0
			=> name        => q (should fail without coercion)
			=> diag        => <<'END_OF_DIAG'
+----+----------------+----+-------------------------------+
| Elt|Got             | Elt|Expected                       |
+----+----------------+----+-------------------------------+
*   0|'not a number'  *   0|expect_data_contract_coerce (  *
|    |                *   1|  'Int',                       *
|    |                *   2|)                              *
+----+----------------+----+-------------------------------+
Compared $data
   got : 'not a number'
expect : Moose contract Int (coerced)
END_OF_DIAG
			;
	};
}

check_test q (unknown contract type)
	=> assumption {
		it q (should fail with unknown contract)
			=> got    => 42
			=> expect => expect_data_contract_coerce ([])
			;
	}
	=> ok          => 0,
	=> actual_ok   => 0,
	=> name        => q (should fail with unknown contract),
	=> diag        => <<'END_OF_DIAG'
+----+-----+----+-------------------------------+
| Elt|Got  | Elt|Expected                       |
+----+-----+----+-------------------------------+
*   0|42   *   0|expect_data_contract_coerce (  *
|    |     *   1|  [],                          *
|    |     *   2|)                              *
+----+-----+----+-------------------------------+
Compared $data
   got : '42'
expect : Unknown contract: ARRAY(0x...)
END_OF_DIAG
	;

had_no_warnings;
done_testing;
