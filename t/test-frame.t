#!/usr/bin/env perl

use v5.14;
use warnings;

use require::relative q (test-helper.pl);

use Test::YAFT qw (test_frame);

sub custom_assert {
	test_frame {
		Test::More::pass q (custom-assert)
	};
}

check_test q (test_frame() should properly alter $Test::Builder::Level)
	=> assumption {
		custom_assert
	}
	=> ok   => 1,
	=>name => q (custom-assert),
	;

had_no_warnings;
done_testing;
