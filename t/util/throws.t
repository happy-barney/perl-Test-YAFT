#!/usr/bin/env perl

use v5.14;
use warnings;

use Test::Load::Helper;

assume_test_yaft_exports throws
	=> by_default => 1
	=> on_demand  => 1
	=> by_tag     => [qw [all default utils helpers]]
	;

check_test q (throws { } block)
	=> assumption {
		it q (should just pass)
			=> got    { die q (foo) }
			=> throws { expect_re (qr (oo)) }
			;
	}
	=> ok          => 1,
	=> actual_ok   => 1,
	=> name        => q (should just pass),
	;

had_no_warnings;
done_testing;
