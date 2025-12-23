
use v5.14;
use warnings;

use Syntax::Construct qw (package-block package-version);

package Test::YAFT::Cmp::Hash {
	use parent qw (Test::Deep::Hash);

	use mro;

	require Scalar::Util;

	sub init {
		my ($self, @hash_data) = @_;

		my $hashref = @hash_data == 1
			? $hash_data[0]
			: { @hash_data }
			;

		return $self->next::method ($hashref);
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

Test::YAFT::Cmp::Hash - Compare hash and its elements

=head1 SYNOPSIS

	Test::YAFT::Cmp::Hash::->new (
		key_0 => expect_item_0,
		key_1 => expect_item_1,
        ...
	)

=head1 AUTHOR

Branislav Zahradník <barney@cpan.org>

=head1 COPYRIGHT AND LICENCE

This module is part of L<Test::YAFT> distribution.

=cut

