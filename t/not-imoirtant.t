#!/usr/bin/env perl

use v5.14;
use warnings;

use require::relative q (test-helper.pl);

assume_test_yaft_exports not_important
	=> by_default => 1
	=> on_demand  => 1
	=> by_tag     => [qw [all default expectations]]
	;

assume_yaft_dump q (Dumper should dump `not_important`)
	=> got { not_important }
	=> expect => <<'END_OF_EXPECTED'
not_important ()
END_OF_EXPECTED
	;

had_no_warnings;
done_testing;
