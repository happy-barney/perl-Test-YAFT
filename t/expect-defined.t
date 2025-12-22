#!/usr/bin/env perl

use v5.14;
use warnings;

use require::relative q (test-helper.pl);

check_test q (success with expectation (defined value))
	=> assumption {
		it q (should pass with 1)
			=> got    { 1 }
			=> expect { expect_defined }
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (should pass with 1)
	;

check_test q (success with complementary expectation (undefined value))
	=> assumption {
		it q (should pass with undef)
			=> got    { undef }
			=> expect { ! expect_defined }
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (should pass with undef)
	;

check_test q (success with double-complementary expectation (defined value))
	=> assumption {
		it q (should pass with defined value)
			=> got    { 1 }
			=> expect { !! expect_defined }
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (should pass with defined value)
	;

check_test q (failure with expectation (undefined value))
	=> assumption {
		it q (should fail with undef)
			=> got    { undef }
			=> expect { expect_defined }
			;
	}
	=> ok          => 0
	=> actual_ok   => 0
	=> name        => q (should fail with undef)
	=> diag        => undef
	;

check_test q (failure with complementary expectation (defined value))
	=> assumption {
		it q (should fail with defined value)
			=> got    { 1 }
			=> expect { ! expect_defined }
			;
	}
	=> ok          => 0
	=> actual_ok   => 0
	=> name        => q (should fail with defined value)
	=> diag        => undef
	;

check_test q (failure with double-complementary expectation (defined value))
	=> assumption {
		it q (should fail with undef)
			=> got    { undef }
			=> expect { !! expect_defined }
			;
	}
	=> ok          => 0
	=> actual_ok   => 0
	=> name        => q (should fail with undef)
	=> diag        => undef
	;

had_no_warnings;
done_testing;
