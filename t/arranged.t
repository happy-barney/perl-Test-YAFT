#!/usr/bin/env perl

use v5.14;
use warnings;

use require::relative q (test-helper.pl);

subtest q (properties arranged in context) => sub {
	arrange { foo => q (foo-value) };

	it q (should return arranged value when property is arranged)
		=> got    { arranged q (foo) }
		=> expect => q (foo-value)
		;

	it q (should return 'undef' when property is not arranged)
		=> got    { arranged q (baz) }
		=> expect => undef
		;

	it q (should return overridden value from assumption arrangement)
		=> arrange { foo => q (foo-override) }
		=> got     { arranged q (foo) }
		=> expect  => q (foo-override)
		;
};

it q (should not see arrangement from another context)
	=> got    { arranged q (foo) }
	=> expect => undef
	;

had_no_warnings;
done_testing;
