#!/usr/bin/env perl

use v5.14;
use warnings;

use require::relative q (test-helper.pl);

assume_test_yaft_exports act
	=> by_default => 1
	=> on_demand  => 1
	=> by_tag     => [qw [all default utils helpers]]
	;

subtest q (act { } block can specify implicit got value builder) => sub {
	my $iterator = [ 42 ];

	act { push @$iterator, $iterator->[-1] + 1; $iterator->[-1] };

	it q (should not execute act { } block when got is specified)
		=> got    => $iterator
		=> expect => [ 42 ]
		;

	it q (should execute act { } block to build contextual got)
		=> expect => 43
		;

	it q (should have side effects)
		=> got    => $iterator
		=> expect => [ 42, 43 ]
		;
};

frame {
	act { [ @_ ] } qw[ foo bar ];

	proclaim foo => q (foo-1);
	proclaim bar => q (bar-1);

	it q (should execute act { } block with specified dependencies (as arguments))
		=> expect => [ q (foo-1), q (bar-1) ]
		;
};

frame {
	act { [ @_ ] } qw[ foo2 bar2 aaa2 ];

	proclaim foo2 => q (foo-2);

	it q (should throw exception with missing dependencies)
		=> throws => q (Act dependencies not fulfilled: aaa2, bar2)
		;
};

frame {
	act { die q (Exception foo) };

	it q (should catch exception thrown by act { } block)
		=> throws => expect_re (qr (^Exception foo at))
		;
};

frame {
	act { die q (foo) };

	it q (should not call act { } block when explicit got is specified)
		=> got    => 1
		=> expect => 1
		;
};

frame {
	act { 1 }
		q (host),
		q (path),
		;

	arrange { host => q (example.com) };

	assume q (throws an exception when dependencies are not resolved)
		=> throws => q (Act dependencies not fulfilled: path)
		;
};

subtest q (only single `act {}` per context) => sub {
	# following tests cannot standard Test::YAFT style because every
	# assumption creates its own subcontext, there `do block`

	assume q (`act {}` can be defined in current context)
		=> got    => do { eval { act { q (parent-context-act) } }; $@ }
		=> expect => expect_false
		;

	assume q (`act {}` is installed)
		=> expect => q (parent-context-act)
		;

	assume q (`act {}` in current context cannot be redefined)
		=> got    => do { eval { act { } }; $@ }
		=> expect => expect_re (qr (Act already known in current context))
		;

	assume q (`act {}` is still available)
		=> expect => q (parent-context-act)
		;

	subtest q (in subcontext one can define new act) => sub {
		assume q (`act {}` can be defined in current context)
			=> got    => do { eval { act { q (subcontext-act) } }; $@ }
			=> expect => expect_false
			;

		assume q (`act {}` is installed)
			=> expect => q (subcontext-act)
		;
	};

	subtest q (in subcontext one can use act from parent context) => sub {
		assume q (`act {}` is inherited)
			=> expect => q (parent-context-act)
			;
	};
};

had_no_warnings;
done_testing;
