
use v5.14;
use warnings;

package Test::YAFT::Test::Deep::Cmp::Instance_Of {
	use parent qw[ Test::Deep::Obj ];

	sub descend {
		my ($self, $got) = @_;

		$self->SUPER::descend ($got)
			&& ref ($got) eq $self->{val};
	}

	sub renderExp {
		my ($self) = @_;

		return "instance of '$self->{val}'";
	}

	1;
};

