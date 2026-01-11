
use v5.14;
use warnings;

use Syntax::Construct qw (package-block package-version);

package Test::YAFT::Cmp::Data_Contract::Moose {
	sub check {
		my ($self, $contract, $got) = @_;

		return $contract->check ($got);
	}

	sub contract {
		my ($self, $contract) = @_;

		return eval {
			require Moose::Util::TypeConstraints;
			Moose::Util::TypeConstraints::find_type_constraint ($contract);
		};
	}

	sub render {
		my ($self, $contract) = @_;

		return q (Moose contract ) . $contract;
	}

	1;
};

__END__

=pod

=encoding utf-8

=head1 NAME

Test::YAFT::Cmp::Data_Contract::Moose - Handle Moose contract

=head1 DESCRIPTION

L<Test::YAFT::Cmp::Data_Contract> implementation hooks for L<Moose> data contracts.

=head1 AUTHOR

Branislav Zahradník <barney@cpan.org>

=head1 COPYRIGHT AND LICENSE

This module is part of L<Test::YAFT> distribution.

=cut
