#!/usr/bin/env perl

use v5.14;
use warnings;

use require::relative q (test-helper.pl);

assume_test_yaft_exports expect_hash
	=> by_default => 1
	=> on_demand  => 1
	=> by_tag     => [qw [all default expectations]]
	;

assume_yaft_dump q (Dumper should produce expect_hash (foo => 1, bar => 2))
	=> got { expect_hash (foo => 1, bar => 2) }
	=> expect => <<'END_OF_EXPECTED'
expect_hash (
  'foo',
  1,
  'bar',
  2,
)
END_OF_EXPECTED
	;

check_test q (expecting plain hashref)
	=> assumption {
		it q (should just pass)
			=> got    => { foo => q (bar) }
			=> expect => { foo => ignore }
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (should just pass)
	;

check_test q (expecting `expect_hash` with hashref)
	=> assumption {
		it q (should just pass)
			=> got    => { foo => q (bar) }
			=> expect => expect_hash ({ foo => ignore })
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (should just pass)
	;

check_test q (expecting `expect_hash` with hash data)
	=> assumption {
		it q (should just pass)
			=> got    => { foo => q (bar) }
			=> expect => expect_hash (foo => ignore)
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (should just pass)
	;

check_test q (expecting `expect_hash` with missing key)
	=> assumption {
		it q (should just pass)
			=> got    => { foo => q (bar) }
			=> expect => expect_hash ()
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (should just pass)
	;

check_test q (expecting `expect_hash` with abundand key)
	=> assumption {
		it q (should just pass)
			=> got    => { foo => q (bar) }
			=> expect => expect_hash (
				foo => ignore,
				bar => ignore,
			);
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (should just pass)
	;

had_no_warnings;
done_testing;
