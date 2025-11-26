#!/usr/bin/env perl

use v5.14;
use warnings;

use require::relative q (test-helper.pl);

use Context::Singleton;

contrive foo => value => 10;

subtest q (subtest should create its own frame) => sub {
	proclaim foo => 42;

	it q (should use value available in inner frame)
		=> got    => deduce (q (foo))
		=> expect => 42
		;
};

it q (should use value available in outer frame)
	=> got    => deduce (q (foo))
	=> expect => 10
	;

Test::Warnings::had_no_warnings;

Test::More::done_testing;

