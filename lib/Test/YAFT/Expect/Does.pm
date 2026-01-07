
use v5.14;
use warnings;

use Syntax::Construct qw (package-block package-version);

package Test::YAFT::Expect::Does {
	use parent qw (Test::YAFT::Cmp);

	use Scalar::Util;

	sub init {
		my ($self, $role) = @_;

		$self->{val} = $role;
	}

	sub descend {
		my ($self, $got) = @_;

		return Scalar::Util::blessed ($got)
			&& $got->DOES ($self->{val});
	}

	sub diag_message {
		my ($self, $where) = @_;

		return "Checking role of $where with DOES()";
	}

	sub renderExp {
		my ($self) = @_;

		return "does role '$self->{val}'";
	}

	1;
};

__END__

=pod

=encoding utf-8

=head1 NAME

Test::YAFT::Expect::Does - Comparator for role composition checking

=head1 SYNOPSIS

	Test::YAFT::Expect::Does::->new (q (My::Role));

=head1 AUTHOR

Branislav Zahradník <barney@cpan.org>

=head1 COPYRIGHT AND LICENCE

This module is part of L<Test::YAFT> distribution.

=cut
