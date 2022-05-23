
use v5.14;
use warnings;

use require::relative "test-helper.pl";

subtest "act { } block can specify implicit got value builder" => sub {
	my $iterator = [ 42 ];

	act { push @$iterator, $iterator->[-1] + 1; $iterator->[-1] };

	it "should not execute act { } block when got is specified"
		=> got    => $iterator
		=> expect => [ 42 ]
		;

	it "should execute act { } block to build contextual got"
		=> expect => 43
		;

	it "should execute act { } block only once per frame"
		=> expect => 43
		;

	it "should have side effects"
		=> got    => $iterator
		=> expect => [ 42, 43 ]
		;
};

had_no_warnings;

done_testing;
