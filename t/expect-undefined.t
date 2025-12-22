#!/usr/bin/env perl

use v5.14;
use warnings;

use require::relative q (test-helper.pl);

check_test q (success with expectation (undefined value))
	=> assumption {
		it q (should pass with undefined)
			=> got    { undef }
			=> expect { expect_undefined }
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (should pass with undefined)
	;

check_test q (success with complementary expectation (defined value))
	=> assumption {
		it q (should pass with defined)
			=> got    { 1 }
			=> expect { ! expect_undefined }
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (should pass with defined)
	;

check_test q (success with double-complementary expectation (undefined value))
	=> assumption {
		it q (should pass with undefined)
			=> got    { undef }
			=> expect { !! expect_undefined }
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (should pass with undefined)
	;

check_test q (failure with expectation (defined value))
	=> assumption {
		it q (should fail with defined)
			=> got    { 1 }
			=> expect { expect_undefined }
			;
	}
	=> ok          => 0
	=> actual_ok   => 0
	=> name        => q (should fail with defined)
	=> diag        => undef
	;

check_test q (failure with complementary expectation (undefined value))
	=> assumption {
		it q (should fail with undefined)
			=> got    { undef }
			=> expect { ! expect_undefined }
			;
	}
	=> ok          => 0
	=> actual_ok   => 0
	=> name        => q (should fail with undefined)
	=> diag        => undef
	;

check_test q (failure with double-complementary expectation (undefined value))
	=> assumption {
		it q (should fail with defined)
			=> got    { 1 }
			=> expect { !! expect_undefined }
			;
	}
	=> ok          => 0
	=> actual_ok   => 0
	=> name        => q (should fail with defined)
	=> diag        => undef
	;

had_no_warnings;
done_testing;
