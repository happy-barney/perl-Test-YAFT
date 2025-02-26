#!/usr/bin/env perl

use v5.14;
use  warnings;

use require::relative q (test-helper.pl);

subtest q (should build tested value using got { } block) => sub {
	check_test {
		it q (got { } block)
			=> got    => got { q (foo) }
			=> expect => q (foo)
			;
	}
	ok          => 1,
	actual_ok   => 1,
	name        => q (got { } block),
	diag        => q (),
};

subtest q (should recognize got { } block also without named parameter) => sub {
	check_test {
		it q (got { } block)
			=> got { q (foo) }
			=> expect => q (foo)
			;
	}
	ok          => 1,
	actual_ok   => 1,
	name        => q (got { } block),
	diag        => q (),
};

subtest q (should test expected failure) => sub {
	check_test {
		it q (got { } block)
			=> got { die bless [ q (foo) ], q (Foo::Bar) }
			=> throws => expect_isa (q (Foo::Bar))
			;
	}
	ok          => 1,
	actual_ok   => 1,
	name        => q (got { } block),
	diag        => q (),
};

subtest q (should fail when expect 'throws' but code lives) => sub {
	check_test {
		it q (got { } block)
			=> got { q (foo) }
			=> throws => ignore
			;
	}
	ok          => 0,
	actual_ok   => 0,
	name        => q (got { } block),
	diag        => <<'DIAG',
Expected to die by lives
DIAG
};

subtest q (should fail when not expecting 'throws' but code dies) => sub {
	check_test {
		it q (got { } block)
			=> got { die q (foo) }
			=> expect => ignore
			;
	}
	ok          => 0,
	actual_ok   => 0,
	name        => q (got { } block),
	diag        => qr/Expected to live but died/,
};

had_no_warnings;

done_testing;
