
use v5.14;
use warnings;

use Syntax::Construct qw (package-block package-version);

package Test::YAFT::Cmp::Hash_Each {
	use parent qw (Test::Deep::Hash_Each);

	use mro;

	sub init {
		my ($self, @hash_data) = @_;

		my $hashref = @hash_data == 1
			? $hash_data[0]
			: { @hash_data }
			;

		return $self->next::method ($hashref);
	}

	1;
};

__END__

=pod

=encoding utf-8

=head1 NAME

Test::YAFT::Cmp::Hash_Each - Compare each value in hash

=head1 SYNOPSIS

	Test::YAFT::Cmp::Hash_Each::->new (
		expect_item
	)

=head1 AUTHOR

Branislav Zahradník <barney@cpan.org>

=head1 COPYRIGHT AND LICENCE

This module is part of L<Test::YAFT> distribution.

=cut

