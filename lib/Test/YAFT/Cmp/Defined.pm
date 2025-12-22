
use v5.14;
use warnings;

use Syntax::Construct qw (package-block package-version);

package Test::YAFT::Cmp::Defined {
	use parent qw (Test::YAFT::Cmp);

	use mro;

	use overload
		q (!)    => \ &_complement,
		fallback => 1,
		;

	sub _complement {
		my ($self) = @_;

		return ref ($self)->new (! $self->_val);
	}

	sub init {
		my ($self, $expect_defined) = @_;

		$expect_defined = 1
			if @_ == 1
			;

		$self->next::method ($expect_defined);
	}

	sub descend {
		my ($self, $got) = @_;

		return ! ($self->_val xor defined $got);
	}

	sub renderGot {
		my ($self, $got) = @_;

		return defined ($got)
			? q (defined value: ) . Test::Deep::render_val ($got)
			: q (undef)
			;
	}

	sub renderExp {
		my ($self) = @_;

		return $self->_val
			? q (defined value)
			: q (undef)
			;
	}

	1;
};

__END__

=pod

=encoding utf-8

=head1 NAME

Test::YAFT::Cmp::Defined - Check whether value is defined or not

=head1 SYNOPSIS

	Test::YAFT::Cmp::Defined::->new ($max)

=head1 AUTHOR

Branislav Zahradník <barney@cpan.org>

=head1 COPYRIGHT AND LICENCE

This module is part of L<Test::YAFT> distribution.

=cut

