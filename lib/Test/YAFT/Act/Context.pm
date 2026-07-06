
use v5.14;
use warnings;

use Syntax::Construct qw (package-block package-version);

package Test::YAFT::Act::Context {
	use Context::Singleton;

	sub new {
		my ($class, $act) = @_;

		bless {
			act => $act,
		}, $class;
	}

	sub _resolve_arguments {
		my ($self) = @_;

		$self->{arguments} //= do {
			my %arguments;

			for my $argument ($self->{act}->dependencies) {
				$arguments{$argument} = deduce ($argument)
					if try_deduce ($argument)
					;
			}

			\ %arguments;
		}
	}

	sub act {
		my ($self) = @_;

		$self->{act}->act;
	}

	sub arguments {
		my ($self) = @_;

		return @{ $self->_resolve_arguments }{$self->{act}->dependencies};
	}

	sub unresolved {
		my ($self) = @_;

		my $arguments = $self->_resolve_arguments;

		grep { ! exists $arguments->{$_} } $self->{act}->dependencies;
	}

	1;
}

__END__

=pod

=encoding utf-8

=head1 NAME

Test::YAFT::Act::Context - Internal implementation of act

=head1 AUTHOR

Branislav Zahradník <barney.cpan@gmail.com>

=head1 COPYRIGHT AND LICENCE

This module is part of L<Test::YAFT> distribution.

=cut
