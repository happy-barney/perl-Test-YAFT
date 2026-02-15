
use v5.14;
use warnings;

use Syntax::Construct qw (package-block package-version);

package Test::YAFT::Argument::Got {
	use parent q (Test::YAFT::Argument::Scalar);

	use constant argument_name => q (got);

	1;
};

__END__

=pod

=encoding utf-8

=head1 NAME

Test::YAFT::Argument::Got - Internal implemention of got { }

=head1 AUTHOR

Branislav Zahradník <barney@cpan.org>

=head1 COPYRIGHT AND LICENCE

This module is part of L<Test::YAFT> distribution.

=cut

