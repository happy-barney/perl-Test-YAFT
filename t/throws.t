#!/usr/bin/env perl

use v5.14;
use warnings;

use require::relative q (test-helper.pl);

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
