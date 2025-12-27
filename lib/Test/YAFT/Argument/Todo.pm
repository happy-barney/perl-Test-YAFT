
use v5.14;
use warnings;

use Syntax::Construct qw (package-block package-version);

package Test::YAFT::Argument::Todo {
	use parent q (Test::YAFT::Argument::Scalar);

	use constant argument_name => q (todo);

	1;
};

__END__

=pod

=encoding utf-8

=head1 NAME

Test::YAFT::Argument::Todo - Internal implemention of todo { }

=head1 AUTHOR

Branislav Zahradník <barney@cpan.org>

=head1 COPYRIGHT AND LICENCE

This module is part of L<Test::YAFT> distribution.

=cut
