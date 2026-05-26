
use v5.14;
use warnings;

use Syntax::Construct qw (package-block package-version);

package Test::YAFT::Expect::Blessed_Ref {
	use parent qw (Test::YAFT::Cmp);

	use Ref::Util;

	sub _create_complement {
		my ($self) = @_;

		return $self->complementary;
	}

	sub descend {
		my ($self, $got) = @_;

		return ($self->is_complement xor Ref::Util::is_blessed_ref ($got));
	}

	sub renderExp {
		my ($self) = @_;

		return $self->is_complement
			? q (Anything but blessed reference)
			: q (Blessed reference)
			;
	}

	1;
};

__END__

=pod

=encoding utf-8

=head1 NAME

Test::YAFT::Expect::Ref_Blessed - Expectation of blessed reference

=head1 SYNOPSIS

	Test::YAFT::Expect::Blessed_Ref::->new

=head1 AUTHOR

Branislav Zahradník <barney@cpan.org>

=head1 COPYRIGHT AND LICENCE

This module is part of L<Test::YAFT> distribution.

=cut
