
use v5.14;
use warnings;

use Syntax::Construct qw (package-block package-version);

package Test::YAFT::Expect::Plain_Ref {
	use parent qw (Test::YAFT::Cmp);

	use Ref::Util;

	use Ref::Util;

	sub _create_complement {
		my ($self) = @_;

		return $self->complementary;
	}

	sub descend {
		my ($self, $got) = @_;

		return ($self->is_complement xor Ref::Util::is_plain_ref ($got));
	}

	sub renderExp {
		my ($self) = @_;

		return $self->is_complement
			? q (Anything but plain (non-blessed) reference)
			: q (Plain (non-blessed) reference)
			;
	}

	1;
};

__END__

=pod

=encoding utf-8

=head1 NAME

Test::YAFT::Expect::Plain_Ref - Comparator for plain (non-blessed) references

=head1 SYNOPSIS

	Test::YAFT::Expect::Plain_Ref::->new

=head1 AUTHOR

Branislav Zahradník <barney@cpan.org>

=head1 COPYRIGHT AND LICENCE

This module is part of L<Test::YAFT> distribution.

=cut
