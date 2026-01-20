
use v5.14;
use warnings;

use Syntax::Construct qw (package-block package-version);

package Test::YAFT::Expect::Ends_With {
	use parent qw (Test::YAFT::Cmp);

	sub descend {
		my ($self, $got) = @_;

		my $suffix = $self->_val;

		return 1
			unless defined $suffix
			;

		return 0
			unless defined $got
			;

		my $len = length $suffix;

		return 1
			unless $len
			;

		return substr ($got, -$len) eq $suffix;
	}

	sub diag_message {
		my ($self, $where) = @_;

		return "Comparing $where as a string suffix";
	}

	sub renderExp {
		my ($self) = @_;

		return "a string ending with '${\ ($self->_val // q () )}'";
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

Test::YAFT::Expect::Ends_With - Expectation for string suffix checking

=head1 SYNOPSIS

	Test::YAFT::Expect::Ends_With::->new (q (World));

=head1 AUTHOR

Branislav Zahradník <barney@cpan.org>

=head1 COPYRIGHT AND LICENSE

This module is part of L<Test::YAFT> distribution.

=cut
