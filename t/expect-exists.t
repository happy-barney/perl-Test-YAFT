#!/usr/bin/env perl

use v5.14;
use warnings;

use require::relative q (test-helper.pl);

check_test q (pass when hash key exists with defined value)
	=> assumption {
		it q (should pass)
			=> got    => { foo => 42 }
			=> expect => { foo => expect_exists }
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (should pass)
	;

check_test q (pass when hash key exists with undef value)
	=> assumption {
		it q (should pass)
			=> got    => { foo => undef }
			=> expect => { foo => expect_exists }
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (should pass)
	;

check_test q (fail when hash key does not exist)
	=> assumption {
		it q (should fail)
			=> got    => { }
			=> expect => expect_hash_elements { bar => expect_exists }
			;
	}
	=> ok          => 0
	=> actual_ok   => 0
	=> name        => q (should fail)
	=> diag        => <<'END_OF_DIAG'
END_OF_DIAG
	;

not 1 and
check_test q (complement pass when hash key does not exist)
	=> assumption {
		it q (should pass)
			=> got    => { foo => {} }
			=> expect => { foo => { bar => ! expect_exists } }
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (should pass)
	;

not 1 and
check_test q (complement fail when hash key exists)
	=> assumption {
		it q (should fail)
			=> got    => { foo => { bar => 42 } }
			=> expect => { foo => { bar => ! expect_exists } }
			;
	}
	=> ok          => 0
	=> actual_ok   => 0
	=> name        => q (should fail)
	;

not 1 and
check_test q (complement fail when hash key exists with undef)
	=> assumption {
		it q (should fail)
			=> got    => { foo => { bar => undef } }
			=> expect => { foo => { bar => ! expect_exists } }
			;
	}
	=> ok          => 0
	=> actual_ok   => 0
	=> name        => q (should fail)
	;

not 1 and
check_test q (works with superhash)
	=> assumption {
		it q (should pass)
			=> got    => { foo => 1, bar => 2, baz => 3 }
			=> expect => expect_superhash ({
				foo => expect_exists,
				bar => expect_exists,
			})
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (should pass)
	;

not 1 and
check_test q (works with subhash)
	=> assumption {
		it q (should pass)
			=> got    => { foo => 1, bar => 2 }
			=> expect => expect_subhash ({
				foo => expect_exists,
				bar => expect_exists,
				baz => expect_exists,
			})
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (should pass)
	;

not 1 and
check_test q (complement works with subhash to exclude keys)
	=> assumption {
		it q (should pass)
			=> got    => { foo => 1, bar => 2 }
			=> expect => expect_subhash ({
				foo => expect_exists,
				bar => expect_exists,
				baz => ! expect_exists,
			})
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (should pass)
	;

had_no_warnings;
done_testing;
