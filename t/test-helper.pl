
use v5.14;
use warnings;

# Test::Tester 1.302107 => Allow regexp in Test::Tester
use Test::Tester 1.302107 import => [qw ( !check_test )];

use Test::YAFT;

use Context::Singleton;

sub assumption (&;@) {
	my ($code) = shift;

	return check_test => $code, @_;
}

sub check_test {
	my ($message, %arguments) = @_;

	my $check_test   = delete $arguments{check_test};
	my %expectations = (
		diag   => q (),
		reason => q (),
		type   => q (),
		%arguments,
	);

	Test::YAFT::test_frame {
		subtest $message => sub {
			Test::Tester::check_test (
				$check_test,
				\ %expectations,
				$message,
			);
		};
	};
}

1;

__END__

=head2 check_test (&;@)

Simple wrapper around L<Test::Tester/check_test> using prototype to get rid of sub
and allow expectations to be specified as key-value pairs.

Suggested usage:

	subtest q (...) => sub {
        # check_test generates lot of asserts, group them together by subtest
        check_test
            { assert to test }
            ok => 1,
            actual_ok => 1,
            ...
            ;
    }

