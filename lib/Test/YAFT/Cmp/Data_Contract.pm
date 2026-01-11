
use v5.14;
use warnings;

use Syntax::Construct qw (package-block package-version);

package Test::YAFT::Cmp::Data_Contract {
	use parent qw (Test::YAFT::Cmp);

	use Test::YAFT::Cmp::Data_Contract::Moose;
	use Test::YAFT::Cmp::Data_Contract::Type::Tiny;

	sub _implementations {
		return (
			Test::YAFT::Cmp::Data_Contract::Type::Tiny::,
			Test::YAFT::Cmp::Data_Contract::Moose::,
		);
	}

	sub descend {
		my ($self, $got) = @_;

		for my $implementation ($self->_implementations) {
			next
				unless defined (my $contract = $implementation->contract ($self->_val))
				;

			$self->{_implementation} = $implementation;

			return $implementation->check ($contract, $got);
		}

		return 0;
	}

	sub renderExp {
		my ($self) = @_;

		return q (Unknown contract: ) . $self->_render_value ($self->_val)
			unless $self->{_implementation}
			;

		return $self->{_implementation}->render ($self->_val);
	}

	1;
};

__END__

=pod

=encoding utf-8

=head1 NAME

Test::YAFT::Cmp::Data_Contract - Comparator for data contract validation

=head1 SYNOPSIS

	Test::YAFT::Cmp::Data_Contract::->new ($contract)

=head1 DESCRIPTION

This comparator validates data against a data contract.

The data contract can be:

=over

=item L<Type::Tiny> instance

=item L<Moose> type name

=back

=head1 AUTHOR

Branislav Zahradník <barney@cpan.org>

=head1 COPYRIGHT AND LICENSE

This module is part of L<Test::YAFT> distribution.

=cut
