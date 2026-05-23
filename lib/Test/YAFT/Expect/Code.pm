
use v5.14;
use warnings;

use Syntax::Construct qw (package-block package-version);

package Test::YAFT::Expect::Code {
	use parent qw (Test::Deep::Code Test::YAFT::Cmp);

	sub descend {
		my ($self, $got) = @_;

		local $_ = $got;

		return $self->Test::Deep::Code::descend ($got);
	}

	1;
};

__END__

=pod

=encoding utf-8

=head1 NAME

Test::YAFT::Expect::Code - Comparator to run custom code

=head1 SYNOPSIS

	Test::YAFT::Expect::Code::->new ($coderef);

Comparator is similar to L<Test::Deep::Code>, in addition it provides
value under test via C<$_> as well.

=head1 AUTHOR

Branislav Zahradník <barney@cpan.org>

=head1 COPYRIGHT AND LICENCE

This module is part of L<Test::YAFT> distribution.

=cut

