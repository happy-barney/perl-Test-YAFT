
use v5.14;
use warnings;

use Syntax::Construct qw (package-block package-version);

package Test::YAFT::Expect::Can {
	use parent qw (Test::YAFT::Cmp);

	sub _expected_methods {
		my ($self) = @_;

		return @{ $self->_val };
	}

	sub init {
		my ($self, @methods) = @_;

		$self->SUPER::init (\ @methods);
	}

	sub descend {
		my ($self, $got) = @_;

		return 0
			unless $self->_expected_methods
			;

		my @missing;
		my @abstract;

		for my $name ($self->_expected_methods) {
			push @missing, $name and next
				unless my $coderef = eval { $got->can ($name) }
				;

			push @abstract, $name
				unless defined &$coderef
				;
		}

		return 1
			unless @missing || @abstract
			;


		$self->data->{expect_can_missing}  = \ @missing;
		$self->data->{expect_can_abstract} = \ @abstract;

		return 0;
	}

	sub diagnostics {
		my ($self, $where, $last) = @_;

		my $missing  = $self->data->{expect_can_missing};
		my $abstract = $self->data->{expect_can_abstract};

		return q (expect_can () called with no method)
			unless $missing
			;

		my @methods = $self->_expected_methods;

		my %status = (
			(map { $_ => q (x) } @methods),
			(map { $_ => q (-) } @$abstract),
			(map { $_ => q ( ) } @$missing),
		);

		my $message_got = $self->_render_value ($last->{got});
		my $message_exp = join qq (\n) =>
			map { qq (    [$status{$_}] $_) }
			sort { $a cmp $b }
			@methods
			;

		my $methods = @methods > 1
			? q (methods)
			: q (method)
			;

		return <<"END_OF_DIAG";
Check whether $message_got 'can' $methods:
$message_exp
END_OF_DIAG
	}

	1;
};

__END__

=pod

=encoding utf-8

=head1 NAME

Test::YAFT::Expect::Can - Comparator verifying object or class can respond to specified methods

=head1 SYNOPSIS

	Test::YAFT::Expect::Can::->new (q (method));
	Test::YAFT::Expect::Can::->new (qw (method1 method2));

=head1 AUTHOR

Branislav Zahradník <barney@cpan.org>

=head1 COPYRIGHT AND LICENCE

This module is part of L<Test::YAFT> distribution.

=cut

