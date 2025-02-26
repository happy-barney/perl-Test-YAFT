#!/usr/bin/env perl

use v5.14;
use warnings;

use require::relative q (test-helper.pl);

frame {
	act { [ @_ ] } qw[ foo bar ];

	arrange { foo => q (foo-1) };
	arrange { bar => q (bar-1) };

	it q (should provide frame act { } block dependencies)
		=> expect => [ q (foo-1), q (bar-1) ]
		;

	it q (should override act { } block dependencies per it)
		=> arrange { foo => q (foo-2) }
		=> expect => [ q (foo-2), q (bar-1) ]
		;

	it q (should accept multiple arrange { } blocks)
		=> arrange { foo => q (foo-2) }
		=> arrange { bar => q (bar-2) }
		=> expect => [ q (foo-2), q (bar-2) ]
		;
};

had_no_warnings;

done_testing;
