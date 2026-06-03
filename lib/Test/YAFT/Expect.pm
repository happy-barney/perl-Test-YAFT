
use v5.14;
use warnings;

use Syntax::Construct qw (package-block package-version);

package Test::YAFT::Expect {
	use parent qw (Test::YAFT::Cmp);

	require Scalar::Util;
	require Test::Deep;

	require Test::YAFT::Expect::Complement;

	sub _create_complement {
		my ($self) = @_;

		return Test::YAFT::Expect::Complement::->new ($self);
	}

	sub _yaft_complement :lvalue {
		my ($self) = @_;

		$self->data->{yaft_complement};
	}

	sub __dump_yaft {
		my ($self, $dumper, $name) = @_;

		return $dumper->_dump_builder ($self->_val, {
			builder => $self->__dump_yaft_builder,
			args    => [ $self->__dump_yaft_args ],
		});
	}

	sub __dump_yaft_args {
		my ($self) = @_;

		return $self->_val;
	}

	sub __dump_yaft_builder {
		my ($self) = @_;

		my $class = Scalar::Util::blessed ($self);

		return qq (expect ${class}::),
	}

	sub expect {
		my $class = shift;

		return $class->new (@_);
	}

	sub is_complement {
		my ($self) = @_;

		return $self->_yaft_complement;
	}

	sub shallow {
		my ($self, $expectation) = @_;

		return Test::YAFT::expect_shallow ($expectation);
	}

	1;
}

__END__

=pod

=encoding utf-8

=head1 NAME

Test::YAFT::Expect - Base class for complement-aware single-value expectations

=head1 SYNOPSIS

	package My::Expectation {
		use parent qw (Test::YAFT::Expect);

		sub descend {
			my ($self, $got) = @_;

			return $self->_expectation_result ($self->_val eq $got);
		}

		sub renderExp {
			my ($self) = @_;

			my $prefix = $self->is_complement ? q (Not ) : q ();
			return $prefix . $self->_render_value ($self->_val);
		}
	}

=head1 DESCRIPTION

C<Test::YAFT::Expect> extends L<Test::YAFT::Cmp> with integrated complement
(negation) support.  Where L<Test::YAFT::Cmp> exposes the complement flag but
leaves applying it to each subclass, C<Test::YAFT::Expect> centralises this
logic so subclasses only need to implement the positive comparison.

=head2 Complement contract

Every subclass must honour the complement flag in two places:

=over

=item C<descend>

Either delegate to C<SUPER::descend> — complement is then applied
automatically — or wrap the raw boolean result with L</_expectation_result>:

	return $self->_expectation_result ($self->_val eq $got);

Alternatively, apply the flag manually with L</is_complement>:

	return $self->is_complement xor $self->_val eq $got;

=item C<renderExp>

Check L</is_complement> to adjust the diagnostic message shown on failure:

	my $prefix = $self->is_complement ? q (Not ) : q ();
	return $prefix . $self->_render_value ($self->_val);

=back

=head2 Methods

=head3 descend

Provides L<Test::YAFT::Cmp/descend> behaviour but complement expectation negates result.

=head3 is_complement

Returns C<true> when this expectation is negated.
Available in both C<descend> and C<renderExp>.

=head3 _expectation_result

	return $self->_expectation_result ($raw_result);

Internal helper method to wrap implementation logic

    return ($self->is_complement xor $raw_result);

=head3 shallow

	$self->shallow ($expectation)

Returns a shallow expectation for C<$expectation>, preventing looking inside
provided expectation.

See L<expect_shallow|Test::YAFT/expect_shallow> or L<shallow|Test::Deep/shallow> for more.

=head1 AUTHOR

Branislav Zahradník <barney@cpan.org>

=head1 COPYRIGHT AND LICENCE

This module is part of L<Test::YAFT> distribution.

=cut

