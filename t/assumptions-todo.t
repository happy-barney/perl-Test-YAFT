#!/usr/bin/env perl

use v5.14;
use warnings;

use require::relative q (test-helper.pl);

assume_test_yaft_exports todo
	=> by_default => 1
	=> on_demand  => 1
	=> by_tag     => [qw [all default utils helpers]]
	;

check_test q (when test fails with string argument todo)
	=> assumption {
		it q (should mark test as TODO)
			=> todo   => q (not yet implemented)
			=> got    => 0
			=> expect => expect_true
			;
	}
	=> ok          => 1
	=> actual_ok   => 0
	=> name        => q (should mark test as TODO)
	=> reason      => q (not yet implemented)
	=> type        => q (todo)
	;

check_test q (when test fails with todo argument builder)
	=> assumption {
		it q (should mark test as TODO with block)
			=> todo   { q (computed reason) }
			=> got    =>  0
			=> expect => expect_true
			;
	}
	=> ok          => 1
	=> actual_ok   => 0
	=> name        => q (should mark test as TODO with block)
	=> reason      => q (computed reason)
	=> type        => q (todo)
	;

check_test q (when test passes with todo)
	=> assumption {
		it q (should mark passing test as TODO)
			=> todo   => q (surprisingly works)
			=> got    => 1
			=> expect => expect_true
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (should mark passing test as TODO)
	=> reason      => q (surprisingly works)
	=> type        => q (todo)
	;

had_no_warnings;
done_testing;
