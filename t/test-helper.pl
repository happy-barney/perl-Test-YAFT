
use v5.14;
use warnings;

use feature qw (state);

# Test::Tester 1.302107 => Allow regexp in Test::Tester
use Test::Tester 1.302107 import => [qw ( !check_test )];

use Test::YAFT;

use Context::Singleton;
use List::Util;

my @assumptions = sort
	q (assume),
	q (it),
	q (there),
	;

sub assumption_under_test;

sub _exists_in_array {
	my ($element, @array) = @_;

	return defined List::Util::first { $_ eq $element } @array
}

sub _anonymous_importer {
	my ($symbol, $exported, $import, $returns) = @_;

	state $serial = 0;
	state $prefix = q (Test::Export::__ANON__::);

	$import = defined ($import)
		? qq (q ($import))
		: q ()
		;

	my $package = $prefix . ++$serial;

	$symbol = q (&) . $symbol
		if $symbol =~ m (^\w)
		;

	$returns //= qq {
		local \$_ = \\ $symbol;

		Ref::Util::is_coderef (\$_) ? defined &\$_ : defined \$_;
	};

	my $eval = qq {
		package ${package} {
			use strict;
			use $exported $import;

			$returns;
		};
	};

	eval $eval
		// die $@
		;
}

sub assume_test_yaft_exports {
	my ($symbol, %args) = @_;

	my %tags = (
		all          => 1,
		default      => 0,
		asserts      => 0,
		expectations => 0,
		foundations  => 0,
		helpers      => 0,
		plumbings    => 0,
		utils        => 0,
	);

	for my $tag (@{ $args{by_tag} // [] }) {
		$tags{$tag} = 1;
	}

	Test::YAFT::test_frame {
		subtest qq (importing $symbol) => sub {
			it q (is exported by default)
				=> got    { _anonymous_importer $symbol => Test::YAFT:: }
				=> expect => expect_bool ($args{by_default})
				;

			it q (is exportable on demand)
				=> got    { _anonymous_importer $symbol => Test::YAFT:: => $symbol }
				=> expect => expect_bool ($args{on_demand})
				;

			for my $tag (sort keys %tags) {
				it qq (is exportable by tag: $tag)
					=> got    { _anonymous_importer $symbol => Test::YAFT:: => qq (:$tag) }
					=> expect => expect_bool ($tags{$tag})
					;
			}
		};
	};
}

sub assumption (&;@) {
	my ($code) = shift;

	return check_test => $code, @_;
}

sub check_assumptions {
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
			for my $assumption (@assumptions) {
				local *assumption_under_test = __PACKAGE__->can ($assumption);
				subtest qq (using $assumption ()) => sub {
					Test::Tester::check_test (
						$check_test,
						\ %expectations,
						qq ($assumption ()),
					);
				};
			}
		};
	};
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

