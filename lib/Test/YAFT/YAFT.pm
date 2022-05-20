
use v5.14;
use warnings;

package Test::YAFT::YAFT v1.0.0 {
	use parent qw[ Exporter ];

	require Test::Deep;
	require Import::Into;
	require Test::YAFT::YAFT;

	our @EXPORT = (
		qw[ it ],
		qw[ expect_true ],
		qw[ expect_false ],
	);

	our @EXPORT_OK = (
		qw[ _test_internals ],
	);

	my $_import_things = sub {
		my ($class, %args) = @_;

		my %do_not_import = map +($_ => 1), @{ $args{exclude} // [] };
		my %redefine      = map +($_ => 1), @{ $args{redefine} // [] };
		my @exported      = @{ $args{exported} };

		my @import =
			grep { ! exists $redefine{$_} }
			grep { ! exists $do_not_import{$_} }
			@exported
			;

		push @EXPORT, @import, keys %redefine;

		$class->import (@import);
	};

	BEGIN {
		Test::Deep->$_import_things (
			exported => \@Test::Deep::EXPORT,
			exclude => [
				qw[ true ],
				qw[ false ],
			],
			redefine => [
				qw[ cmp_deeply ],
				qw[ cmp_bag ],
				qw[ cmp_set ],
				qw[ cmp_methods ],
			],
		);

	}


	use Test::Deep qw[ :all !cmp_deeply !cmp_bag !cmp_set !cmp_methods !true !false ];
	use Test::Differences qw[];
	use Test::More v0.960 qw[];

	use Safe::Isa;

	my %do_not_reexport = map +($_ => 1), (
		# From Test::Deep
		qw[ true ],                      # replaced by expect_true
		qw[ false ],                     # replaced by expect_false
	);

	our @EXPORT = (
		qw[ expect_false ],
		qw[ expect_true ],
		qw[ it ],
		(grep { ! $do_not_reexport{$_} } @Test::Deep::EXPORT),
	);

	our @EXPORT_OK = (
		'_test_internals',
		(grep { ! $do_not_reexport{$_} } @Test::Deep::EXPORT_OK),
	);

	sub _test_internals :prototype(&) {
		my ($code) = @_;

		# 1 - caller sub context
		# 2 - this sub context
		# 3 - code arg context
		local $Test::Builder::Level = $Test::Builder::Level + 3;

		$code->();
	}

	sub cmp_bag {
		my ($message, %args) = @_;

		$args{expect} = bag $args{expect};

		@_ = ($message, %args);

		goto &it;
	}

	sub cmp_set {
		my ($message, %args) = @_;

		$args{expect} = bag $args{expect};

		@_ = ($message, %args);

		goto &it;
	}

	sub cmp_methods {
		my ($message, %args) = @_;

		$args{expect} = methods $args{expect};

		@_ = ($message, %args);

		goto &it;
	}

	sub cmp_deeply {
		goto &it;
	}

	sub expect_true {
		Test::Deep::bool (1);
	}

	sub expect_false {
		Test::Deep::bool (0);
	}

	sub it {
		my ($title, %params) = @_;

		test_internals {
			my $got    = $params{got};
			my $expect = $params{expect};

			return Test::More::ok $got xor $expect->{val}, $title
				if $expect->isa (Test::Deep::Boolean::);

			return Test::More::pass $title
				if Test::Deep::eq_deeply $got, $expect, $title;

			Test::Differences::eq_or_diff $got, $expect, $title;
		};
	}

	sub ok {
		it @_, got => expect_true;
	}

	sub nok {
		it @_, got => expect_false;
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

=head2 Motivation

There are multiple C<Test> libraries, each of with some good parts,
as well as with some parts solved better by another library - but
these libraries do not cooperate.

For example:

=over

=item Test::Difference

Quite an improvement regarding reporting differences but doesn't accept
L<Test::Deep> expectations.

=item Test::Exception

Decent idea but it doesn't accept L<Test::Deep> expectations

=item Test::Spec

Another decent idea but support for multiple expectations on same
result is questionable (doable but reporting sucks).

=over

=head2 Goals

Test base should be entry point for newbies into project, giving them
explanation what and why.

Good test should also be understandable by any person involved in project,
even those not capable of reading perl (well, some are still need, but not
as a code, rather as a punctuation/markdown/...)

=over

=item Test message is mandatory

Test without declaration why it exists makes no sense.
From readability point of view it's easier to read a test code when one knows
what to expect (in opposite to common optional test message at the end.

	it "should not allow unauthorized user to list available products"
		=> arrange { authorized_user => none }
		=> act     { rest_api_operation 'list_available_products' }
		=> expect  { rest_api_response NOT_ALLOWED }
		;

=item Every other parameter is explicitely named

	it "should be like that"
		=> got    => $got
		=> expect => $expect
		;

=item Use context oriented approach

Allow multiple tests on same value

	got { $got };

	it "should ..."
		=> expect => ...
		;

	it "should ... "
		=> expect => another ...
		;

=back

=head1 TEST PRIMITIVES

=head2 it

	it "should be like that"
		=> got    => $got
		=> expect => $expect
		;

Basic test primitive. It compares what you got with with you expect
(using L<Test::Deep> to compare, L<Test::Difference> to report)

=head2 they

=head2 is

=head2 cmp_deeply

Aliases for L</it> with same arguments.

=head2 ok

	ok "it should be like that"
		=> got    => $got
		;

Similar to L<Test::More>'s C<ok>.

=head1 TEST UTILS

=head1 EXPECTATIONS

=head2 Test::Deep

Most C<Test::Deep> exports are reexported.

=head2 expect_true

Alias for C<Test::Deep::bool (1)>

=head3 expect_false

Alias for C<Test::Deep::bool (0)>

=head3 pass

=head3 fail

=head3 done_testing

Reexport from L<Test::More>.

=head3 had_no_warnings

Reexport from L<Test::Warnings>

=head1 AUTHOR

Branislav Zahradník <barney@cpan.org>

=head1 COPYRIGHT AND LICENCE

Test::YAFT distribution is distributed under Artistic Licence 2.0.

=cut


