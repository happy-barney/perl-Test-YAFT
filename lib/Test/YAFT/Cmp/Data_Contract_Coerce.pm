
use v5.14;
use warnings;

use Syntax::Construct qw (package-block package-version);

package Test::YAFT::Cmp::Data_Contract_Coerce {
	use parent qw (Test::YAFT::Cmp::Data_Contract);

	use Test::YAFT::Cmp::Data_Contract_Coerce::Moose;
	use Test::YAFT::Cmp::Data_Contract_Coerce::Type::Tiny;

	sub _implementations {
		return (
			Test::YAFT::Cmp::Data_Contract_Coerce::Type::Tiny::,
			Test::YAFT::Cmp::Data_Contract_Coerce::Moose::,
		);
	}

	1;
};

__END__

=pod

=encoding utf-8

=head1 NAME

Test::YAFT::Cmp::Data_Contract_Coerce - Comparator for data contract validation with coercion

=head1 SYNOPSIS

	Test::YAFT::Cmp::Data_Contract_Coerce::->new ($contract)

=head1 DESCRIPTION

This comparator validates data against a contract, attempting to coerce the value first
if coercion is available.

The contract can be:

=over

=item L<Type::Tiny> instance

=item L<Moose> type name

=back

=head1 AUTHOR

Branislav Zahradník <barney@cpan.org>

=head1 COPYRIGHT AND LICENSE

This module is part of L<Test::YAFT> distribution.

=cut
