
use v5.14;
use warnings;

use Syntax::Construct qw (package-block package-version);

package Test::YAFT::Cmp::Placeholder {
	use parent qw (Test::YAFT::Cmp);

	use Context::Singleton;
	use Test::Deep qw ();

	use mro;

	sub init {
		my ($self, $name, $expectation) = @_;

		$self->{_name}        = $name;
		$self->{_singleton}   = q (placeholder:) . $name;
		$self->{_expectation} = $expectation;

		proclaim $self->{_singleton}, +{ }
			unless try_deduce $self->{_singleton}
			;
	}

	sub _expectation {
		$_[0]->{_expectation};
	}

	sub _name {
		$_[0]->{_name};
	}

	sub _singleton {
		$_[0]->{_singleton};
	}

	sub _status {
		my ($self, $status) = @_;

		return deduce $self->_singleton;
	}

	sub value {
		my ($self) = @_;

		return $self->_status->{value};
	}

	sub descend {
		my ($self, $got) = @_;

		my $status = $self->_status;

		# Subsequent evaluation - compare with stored value
		if (exists $status->{value}) {
			$self->SUPER::init ($status->{value});
			return $self->next::method ($got);
		}

		# First evaluation - store value
		$status->{value} = $got;
		$status->{descend} = defined $self->_expectation
			? Test::Deep::descend ($got, $self->_expectation)
			: 1
			;

		return $status->{descend};
	}

	sub renderExp {
		my ($self) = @_;

		return q (Placeholder: ) . $self->_name;
	}

	1;
};

__END__

=pod

=encoding utf-8

=head1 NAME

Test::YAFT::Cmp::Placeholder - Comparator for placeholder values

=head1 SYNOPSIS

	Test::YAFT::Cmp::Placeholder->new (q (name))
	Test::YAFT::Cmp::Placeholder->new (q (name), $expectation)

=head1 DESCRIPTION

This comparator implements placeholder behavior:

Placeholder value is stored in conext

=over 4

=item First evaluation

Stores the C<$got> value internally under the given name.
If an optional expectation is provided, validates C<$got> against it and returns the validation result.
Otherwise returns true.

=item Subsequent evaluations

Compares C<$got> with the previously stored value.

=back

=head1 AUTHOR

Branislav Zahradník <barney@cpan.org>

=head1 COPYRIGHT AND LICENSE

This module is part of L<Test::YAFT> distribution.

=cut
