
use v5.14;
use warnings;

use Syntax::Construct qw (package-block package-version);

package Test::YAFT::Expect::Complement {
	use parent qw (Test::YAFT::Cmp);

	require Test::Deep;
	require overload;

	require Safe::Isa;

	sub _create_complement {
		my ($self) = @_;

		return $self->_val;
	}

	sub __dump_yaft {
		my ($self, $dumper, $name) = @_;

		my $result = q (! ) . $dumper->_dump ($self->_val, $name);

		return $result =~ s (^ ([!] \* [!] \*)+) ()gxr;
	}

	sub init {
		my ($self, $value) = @_;

		$value = Test::YAFT::Cmp->new ($value)
			unless $value->$Safe::Isa::_isa (Test::Deep::Cmp::);

		return $self->SUPER::init ($value);
	}

	sub descend {
		my ($self, $got) = @_;

		$self->_yaft_complement = ! $self->_yaft_complement;

		return ! $self->_val->descend ($got);
	}

	sub renderExpComplement {
		my ($self) = @_;

		return $self->_val->renderExp;
	}

	sub renderExp {
		my ($self) = @_;

		return $self->_val->renderExpComplement
			if $self->_val->can (q (renderExpComplement))
			;

		return q (Value different from: ) . $self->_val->renderExp;
	}

	1;
}

__END__

=pod

=encoding utf-8

=head1 NAME

Test::YAFT::Expect::Complement - Implementation class for negated expectation

=head1 AUTHOR

Branislav Zahradník <barney@cpan.org>

=head1 COPYRIGHT AND LICENCE

This module is part of L<Test::YAFT> distribution.

=cut

