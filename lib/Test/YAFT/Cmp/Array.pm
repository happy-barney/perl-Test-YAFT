
use v5.14;
use warnings;

use Syntax::Construct qw (package-block package-version);

package Test::YAFT::Cmp::Array {
	use parent qw (Test::Deep::Array);

	use mro;

	sub init {
		my ($self, @expectations) = @_;

		return $self->next::method (\ @expectations);
	}

	sub descend {
		my ($self, $got) = @_;

		local $Test::Deep::Snobby = 0;

		return $self->next::method ($got);
	}

	1;
};

__END__

=pod

=encoding utf-8

=head1 NAME

Test::YAFT::Cmp::Array - Compare array and its elements

=head1 SYNOPSIS

	Test::YAFT::Cmp::Array->new (
		expect_item_0,
		expect_item_1,
        ...
	)

=head1 AUTHOR

Branislav Zahradník <barney@cpan.org>

=head1 COPYRIGHT AND LICENCE

This module is part of L<Test::YAFT> distribution.

=cut

