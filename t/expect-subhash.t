#!/usr/bin/env perl

use v5.14;
use warnings;

use require::relative q (test-helper.pl);

assume_test_yaft_exports expect_subhash
	=> by_default => 1
	=> on_demand  => 1
	=> by_tag     => [qw [all default expectations]]
	;

assume_yaft_dump q (Dumper should produce expect_subhash (foo => 1))
	=> got { expect_subhash (foo => 1) }
	=> expect => <<'END_OF_EXPECTED'
expect_subhash (
  'foo',
  1,
)
END_OF_EXPECTED
	;

check_test q (success with hashref argument)
	=> assumption {
		it q (should pass with hashref)
			=> got    => { a => 1 }
			=> expect => expect_subhash ({ a => 1, b => 2 })
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (should pass with hashref)
	;

check_test q (success with hash content)
	=> assumption {
		it q (should pass with hash)
			=> got    => { a => 1 }
			=> expect => expect_subhash (a => 1, b => 2)
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (should pass with hash)
	;

had_no_warnings;
done_testing;
