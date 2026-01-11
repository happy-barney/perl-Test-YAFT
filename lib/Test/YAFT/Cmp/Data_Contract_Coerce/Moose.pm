
use v5.14;
use warnings;

use Syntax::Construct qw (package-block package-version);

package Test::YAFT::Cmp::Data_Contract_Coerce::Moose {
	use parent q (Test::YAFT::Cmp::Data_Contract::Moose);

	use mro;

	sub check {
		my ($self, $contract, $got) = @_;

		$got = $contract->coerce ($got)
			if $contract->has_coercion
			;

		return $contract->check ($got);
	}

	sub render {
		my ($self, $contract) = @_;

		return $self->next::method ($contract) . q ( (coerced));
	}

	1;
};

__END__

=pod

=encoding utf-8

=head1 NAME

Test::YAFT::Cmp::Data_Contract_Coerce::Moose - Handle Moose contract

=head1 DESCRIPTION

L<Test::YAFT::Cmp::Data_Contract_Coerce> implementation hooks for L<Moose> data contracts.

=head1 AUTHOR

Branislav Zahradník <barney@cpan.org>

=head1 COPYRIGHT AND LICENSE

This module is part of L<Test::YAFT> distribution.

=cut
