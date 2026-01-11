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
		or skip q (Type::Tiny not available), 1
		;

	require Types::Standard;

	assume_yaft_dump q (Dumper should dump `expect_data_contract (Type::Tiny contract)`)
		=> got { expect_data_contract (Types::Standard::Int ()) }
		=> expect => <<'END_OF_EXPECTED'
expect_data_contract (
  Int,
)
END_OF_EXPECTED
		;

	subtest q (Type::Tiny) => sub {
		check_test q (successful validation)
			=> assumption {
				it q (should pass with valid 'Int')
					=> got    => 42
					=> expect => expect_data_contract (Types::Standard::Int ())
				;
			}
			=> ok          => 1
			=> actual_ok   => 1
			=> name        => q (should pass with valid 'Int')
			;

		check_test q (failed validation)
			=> assumption {
				it q (should fail with invalid 'Int')
					=> got    => q (not a number)
					=> expect => expect_data_contract (Types::Standard::Int ())
					;
			}
			=> ok          => 0
			=> actual_ok   => 0
			=> name        => q (should fail with invalid 'Int')
			=> diag        => undef
			;
	};
}

SKIP: {
	eval { require Moose::Util::TypeConstraints; 1 }
		or skip q (Moose not available), 1
		;

	assume_yaft_dump q (Dumper should dump `expect_data_contract (Moose contract)`)
		=> got { expect_data_contract (q (Int)) }
		=> expect => <<'END_OF_EXPECTED'
expect_data_contract (
  'Int',
)
END_OF_EXPECTED
		;

	Moose::Util::TypeConstraints::->import;

	subtest q (Moose) => sub {
		check_test q (successful validation)
			=> assumption {
				it q (should pass with valid 'Int')
					=> got    => 42
					=> expect => expect_data_contract (q (Int))
					;
			}
			=> ok          => 1,
			=> actual_ok   => 1,
			=> name        => q (should pass with valid 'Int'),
			;

		check_test q (failed Moose type constraint validation)
			=> assumption {
				it q (should fail with invalid Int)
					=> got    => q (not a number)
					=> expect => expect_data_contract (q (Int))
					;
			}
			=> ok          => 0,
			=> actual_ok   => 0,
			=> name        => q (should fail with invalid Int),
			=> diag        => undef
			;
	};
}

check_test q (unknown contract type)
	=> assumption {
		it q (should fail with unknown contract)
			=> got    => 42
			=> expect => expect_data_contract (sub { })
			;
	}
	=> ok          => 0,
	=> actual_ok   => 0,
	=> name        => q (should fail with unknown contract),
	=> diag        => undef
	;

had_no_warnings;
done_testing;
