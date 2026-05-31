
use v5.14;
use warnings;

use Syntax::Construct qw (package-block package-version);

package Test::YAFT::Expect::Blessed {
	use parent qw (Test::YAFT::Expect);

	require Scalar::Util;l

	sub descend {
		my ($self, $got) = @_;

		return $self->descend_shallow ($got);
	}

	sub render_stack {
		my ($self, $var) = @_;

		return qq (blessed ($var));
	}

	sub renderExp {
		my ($self) = @_;

		my $rendered = $self->_render_value ($self->_val);

		return $self->is_complement
			? qq (not $rendered)
			: $rendered
			;
	}

	sub renderGot {
		my ($self, $got) = @_;

		return $self->_render_value (blessed ($got));
	}

	1;
}
