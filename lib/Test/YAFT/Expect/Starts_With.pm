
use v5.14;
use warnings;

use Syntax::Construct qw (package-block package-version);

package Test::YAFT::Expect::Starts_With {
	use parent qw (Test::YAFT::Cmp);

	sub descend {
		my ($self, $got) = @_;

		my $prefix = $self->_val;

		return 1
			unless defined $prefix
			;

		return 0
			unless defined $got
			;

		return substr ($got, 0, length $prefix) eq $prefix;
	}

	sub diag_message {
		my ($self, $where) = @_;

		return "Comparing $where as a string prefix";
	}

	sub renderExp {
		my ($self) = @_;

		return "a string starting with '${\ ($self->_val // q () )}'";
	}

	sub renderGot {
		my ($self, $got) = @_;

		return defined $got
			? "'$got'"
			: 'undef';
	}

	1;
};

__END__

=pod

=encoding utf-8

=head1 NAME

Test::YAFT::Expect::Starts_With - Expectation for string prefix checking

=head1 SYNOPSIS

	Test::YAFT::Expect::Starts_With::->new (q (Hello));

=head1 AUTHOR

Branislav Zahradník <barney@cpan.org>

=head1 COPYRIGHT AND LICENSE

This module is part of L<Test::YAFT> distribution.

=cut
