
use v5.14;
use warnings;

use Syntax::Construct qw (package-block package-version);

package Test::YAFT::Act {
	use Test::YAFT::Act::Context;

	sub new {
		my ($class, $act, @dependencies) = @_;

		return bless {
			act          => $act,
			dependencies => \ @dependencies,
		}, $class;
	}

	sub act {
		$_[0]->{act};
	}

	sub context {
		Test::YAFT::Act::Context::->new ($_[0]);
	}

	sub dependencies {
		@{ $_[0]->{dependencies} }
	}

	1;
};

__END__

=pod

=encoding utf-8

=head1 NAME

Test::YAFT::Act - Internal implementation of act

=head1 AUTHOR

Branislav Zahradník <barney.cpan@gmail.com>

=head1 COPYRIGHT AND LICENCE

This module is part of L<Test::YAFT> distribution.

=cut
