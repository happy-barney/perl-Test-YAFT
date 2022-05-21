
use v5.14;
use warnings;

package Test::YAFT::Test::Deep::Cmp::Val {
	use parent qw[ Test::Deep::Cmp ];

	sub init {
		my ($self, $val) = @_;

		$self->{val} = $val;
	}

	sub _val {
		$_[0]->{val};
	}

	1;
};

__END__

=pod

=encoding utf-8

=head1 NAME

Test::YAFT::Test::Deep::Cmp::Val - Intermediate class for single param comparators

=head1 SYNOPSIS

	package My::Cmp {
		use parent qw[ Test::YAFT::Test::Deep::Cmp::Val ];

		sub descend {
			my ($self, $got) = @_;

			return $self->_val eq $got;
		}
	}

=head1 DESCRIPTION

Most of C<Test::Deep> comparators uses only single expected value so
little bit of abstraction saves few lines of code.

=head2 Constructor

	Comparator->new ('Foo')

=head2 Methods

=head3 _val

Returns expected value provided earlier to constructor

=head1 AUTHOR

Branislav Zahradník <barney@cpan.org>

=head1 COPYRIGHT AND LICENCE

This module is part of L<Test::YAFT> distribution.

=cut

