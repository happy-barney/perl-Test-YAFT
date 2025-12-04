#!/usr/bin/env perl

use v5.14;
use warnings;

use require::relative q (test-helper.pl);

check_test q (when just fails)
	=> assumption {
		fail q (when just fails);
	}
	=> ok          => 0,
	=> actual_ok   => 0,
	=> name        => q (when just fails),
	=> diag        => undef,
	;

check_test q (when failing with custom diag)
	=> assumption {
		fail q (when failing with custom diag)
			=> diag   => q (custom diag)
			;
	}
	=> ok          => 0,
	=> actual_ok   => 0,
	=> name        => q (when failing with custom diag),
	=> diag        => q (custom diag),
	;

had_no_warnings;
done_testing;
