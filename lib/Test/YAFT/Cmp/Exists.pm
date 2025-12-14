
use v5.14;
use warnings;

use Syntax::Construct qw (package-block package-version);

package Test::YAFT::Cmp::Exists {
	use parent qw (Test::YAFT::Cmp);

	use mro;

	use Scalar::Util;

	my $DNE = Scalar::Util::refaddr ($Test::Deep::DNE);

	use overload
		q (!)    => \ &_complement,
		fallback => 1,
		;

	sub _create_complement {
		my ($self) = @_;

		return $self->complementary;
	}

	sub value_exists {
		my ($self, $value) = @_;

		return
			unless ref $value
			;

		return $DNE != Scalar::Util::refaddr ($value);
	}

	sub descend {
		my ($self, $got) = @_;


		return ($self->is_complement xor ! $self->value_exists ($got));
	}

	sub renderGot {
		my ($self, $got) = @_;

		return $self->value_exists ($got)
			? q (value exists)
			: q (value does not exist)
			;
	}

	sub renderExp {
		my ($self) = @_;

		return $self->is_complement
			? q (value does not exist)
			: q (value exists)
			;
	}

	1;
};

__END__

=pod

=encoding utf-8

=head1 NAME

Test::YAFT::Cmp::Exists - Check whether value exists or not

=head1 SYNOPSIS

	Test::YAFT::Cmp::Exists::->new

=head1 AUTHOR

Branislav Zahradník <barney@cpan.org>

=head1 COPYRIGHT AND LICENCE

This module is part of L<Test::YAFT> distribution.

=cut

