
use v5.14;
use warnings;

use Syntax::Construct 'package-version', 'package-block';

package Test::YAFT {
	use parent 'Exporter::Tiny';

	use Context::Singleton;
	use Ref::Util qw[];
	use Safe::Isa qw[];

	use Test::Deep qw[];
	use Test::Differences qw[];
	use Test::More qw[];

	use Test::YAFT::Attributes;

	sub expect_false            :Exported(all,expectations);
	sub expect_true             :Exported(all,expectations);
	sub it                      :Exported(all,asserts);
	sub nok                     :Exported(all,asserts);
	sub ok                      :Exported(all,asserts);
	sub test_frame (&)          :Exportable(all,plumbings);
	sub there                   :Exported(all,asserts)      :From(\&it);

	sub _run_diag;

	sub _run_diag {
		my ($diag, $stack, $got) = @_;

		return
			unless $diag;

		return Test::More::diag ($diag->($stack, $got))
			if Ref::Util::is_coderef ($diag);

		return Test::More::diag (@$diag)
			if Ref::Util::is_arrayref ($diag);

		return Test::More::diag ($diag);
	}

	sub expect_false {
		Test::Deep::bool (0);
	}

	sub expect_true {
		Test::Deep::bool (1);
	}

	sub it {
		my ($title, %params) = @_;

		my ($ok, $stack, $got);
		test_frame {
			$got    = $params{got};
			my $expect = $params{expect};

			($ok, $stack) = Test::Deep::cmp_details ($got, $expect);

			return Test::More::ok ($ok, $title)
				if $ok
				|| defined $params{diag}
				|| $expect->$Safe::Isa::_isa (Test::Deep::Boolean::)
				;

			Test::Differences::eq_or_diff $got, $expect, $title;
			Test::More::diag (Test::Deep::deep_diag ($stack))
				if ref $got || ref $expect;

			return;
		} or _run_diag ($params{diag}, $stack, $got);

		return $ok;
	}

	sub nok {
		my ($message, %params) = @_;

		test_frame {
			it $message, %params, expect => expect_false, diag => ''
		}
	}

	sub ok {
		my ($message, %params) = @_;

		test_frame {
			it $message, %params, expect => expect_true, diag => ''
		}
	}

	sub test_frame (&) {
		my ($code) = @_;

		# 1 - caller sub context
		# 2 - this sub context
		# 3 - frame
		# 4 - code arg context
		local $Test::Builder::Level = $Test::Builder::Level + 4;

		&frame ($code);
	}

	1;
};

__END__

=pod

=encoding utf-8

=head1 NAME

Test::YAFT - Yet another testing framework

=head1 SYNOPSIS

=head1 DESCRIPTION

This module combines features of multiple test libraries providing
its own, BDD inspired, Context oriented, testing approach.

=head1 GLOSSARY

=over

=item assert

Assert function performs actual value comparison.

=item expectation

Expectation function provides object (L<Test::Deep::Cmp>) describing
expected value.

=item plumbing

Similar concept to git, plumbing functions are used to build
higher level asserts, expectations, and/or tools.

=back

=head1 EXPORTED SYMBOLS

This module exports symbols using L<Exporter::Tiny>.

=head2 Asserts

	use Test::YAFT qw[ :asserts ];

Assert functions are exported by default.

Every assert accepts (if any) test message as a first (positional) parameter,
with restof parameters using named approach.

When assert performs multiple expectations internally, it always reports
as one, using provided test message, failing early.

Named parameters are provided either via key/value pairs

	ok "test title"
		=> got => $value
		;

or via builder functions

	ok "test title"
		=> got { build got }
		;

Coding style note: I suggest to use coding style as presented in all examples,
with one parameter per line, leading with fat comma.

=head3 it

	it "should be ..."
		=> got    => ...
		=> expect => ...
		;

Basic test primitive, used by all other test functions.
It uses L<Test::Deep>'s C<cmp_deeply> to compare values.

In addition to C<Test::Deep>'s stack also uses L<Test::Difference> to report
differences when failed.

When expected value is L<Test::Deep::Bool> then it uses L<Test::More>'s C<ok>.

Accepted named parameters:

=over

=item diag

Custom diagnostic message, printed out in case of failure.

When specified no other diagnostic message is printed.

Can be string, arrayref of strings, or coderef returning strings.

Coderef gets two parameters - Test::Deep stack and value under test.

=item expect

Expected value.

=item got

Value under test.

=back

=head3 nok

	nok "shouldn't be ..."
		=> got    => ...
		;

Simple shortcut to expect value behaving like boolean false.

=head3 ok

	ok "should be ..."
		=> got    => ...
		;


Simple shortcut to expect value behaving like boolean true.

=head3 there

	there "should be ..."
		=> got    => ...
		=> expect => ...
		;

Alias for C<it>, providing convenient word to form meaningful English sentence

=head2 Expectations

Every expectation returns L<Test::Deep::Cmp> object.

=head3 expect_false

Boolean expectation.

=head3 expect_true

Boolean expectation.

=head2 Helper Functions

	use Test::YAFT qw[ :helpers ];

Helper functions are exported by default.

Functions helping to organize your tests.

=head2 Plumbing Functions

	use Test::YAFT qw[ :plumbings ];

Functions helping writing your custom asserts, expectations, and/or tools.

Plumbing functions are not exported by default.

=head3 test_frame (&)

	use Test::YAFT qw[ test_frame ];
	sub my_assert {
		test_frame {
			...
		};
	}

Utility function to populate required boring details like

=over

=item adjusting L<Test::Builder/level>

=item create L<Context::Singleton/frame>

=back

=head1 AUTHOR

Branislav Zahradník <barney@cpan.org>

=head1 COPYRIGHT AND LICENCE

Test::YAFT distribution is distributed under Artistic Licence 2.0.

=cut

