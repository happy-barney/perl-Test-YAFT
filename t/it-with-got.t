#!/usr/bin/env perl

use v5.14;
use  warnings;

use require::relative q (test-helper.pl);

check_test q (should build tested value using got { } block)
	=> assumption {
		it q (got { } block)
			=> got    => got { q (foo) }
			=> expect => q (foo)
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (got { } block)
	;

check_test q (should recognize got { } block also without named parameter)
	=> assumption {
		it q (got { } block)
			=> got { q (foo) }
			=> expect => q (foo)
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (got { } block)
	;

check_test q (should test expected failure)
	=> assumption {
		it q (got { } block)
			=> got { die bless [ q (foo) ], q (Foo::Bar) }
			=> throws => expect_isa (q (Foo::Bar))
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (got { } block)
	;

check_test q (should fail when expect 'throws' but code lives)
	=> assumption {
		it q (got { } block)
			=> got { q (foo) }
			=> throws => ignore
			;
	}
	=> ok          => 0
	=> actual_ok   => 0
	=> name        => q (got { } block)
	=> diag        => <<'EXPECTED_DIAG'
Expected to die by lives
EXPECTED_DIAG
	;

check_test q (should fail when not expecting 'throws' but code dies)
	=> assumption {
		it q (got { } block)
			=> got    { die q (foo) }
			=> expect => ignore
			;
	}
	=> ok          => 0
	=> actual_ok   => 0
	=> name        => q (got { } block)
	=> diag        => qr (Expected to live but died)
	;

had_no_warnings;
done_testing;
