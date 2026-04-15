
use v5.14;
use warnings;

use Syntax::Construct qw (package-block package-version);

package Test::YAFT::Argument::Override {
	use parent q (Test::YAFT::Argument::Array);

	use mro;

	use Context::Singleton;
	use Sub::Override v0.120;

	use constant argument_name => q (override);

	sub _decode_override_code {
		my ($self, @spec) = @_;

		my $value = pop @spec;

		return $value
			if Ref::Util::is_plain_coderef ($value)
			;

		return sub { $value };
	}

	sub _decode_override_function {
		my ($self, @spec) = @_;

		return $spec[0]
			if @spec == 2
			;

		return $spec[1]
			if index ($spec[1], q (::)) > -1
			;

		my ($target, $function) = @spec;

		$target = ref ($target)
			if Scalar::Util::blessed ($target)
			;

		$target =~ s (::$) ();

		return join q (::) => $target, $function;
	}

	sub _decode_override_refaddr {
		my ($self, @spec) = @_;

		return @spec == 3
			? Scalar::Util::refaddr ($spec[0])
			: 0
			;
	}

	sub _original_coderef {
		my ($self, $name) = @_;

		no strict q (refs);
		my $original = *{$name}{CODE};

		return sub { goto $original }
			if defined $original
			;

		my ($package, $function) = $name =~ m (^(.+)::([^:]+)$);

		return $package->can ($function);
	}

	sub _override_config {
		my ($self, $function) = @_;

		my $singleton = qq (Test::YAFT::override<$function>);

		return deduce $singleton
			if is_deduced $singleton
			;

		proclaim $singleton, my $config = {
			instance => { },
			original => $self->_original_coderef ($function),
			guard    => Sub::Override::->new,
			overload => undef,
		};

		my $method = defined *{$function}{CODE}
			? q (replace)
			: q (inject)
			;

		my $override = sub {
			my $refaddr = Scalar::Util::refaddr ($_[0]) // 0;

			return
				unless my $code = $config->{instance}{$refaddr}
				// $config->{overload}
				// $config->{original}
				;

			no warnings q (redefine);

			local *original::function = $config->{original} // sub { };
			local *original::method   = $config->{original} // sub { };

			$code->(@_);
		};

		$config->{guard}->$method ($function => $override);

		return $config;
	}

	sub resolve {
		my ($self) = @_;

		return $self->{resolved}
			if exists $self->{resolved}
			;

		my @spec = $self->next::method;
		unshift @spec, @{ shift @spec }
			if Ref::Util::is_plain_arrayref ($spec[0])
			;

		my $function  = $self->_decode_override_function (@spec);
		my $refaddr   = $self->_decode_override_refaddr  (@spec);
		my $code      = $self->_decode_override_code     (@spec);

		my $config = $self->_override_config ($function);

		if ($refaddr) {
			$config->{instance}{$refaddr} = $code;
		} else {
			$config->{overload} = $code;
		}

		$self->{resolved} = 1;

		return;
	}

	sub DESTROY {
		my ($self) = @_;

		$self->resolve;
	}

	1;
};

__END__

=pod

=encoding utf-8

=head1 NAME

Test::YAFT::Override - Internals under override { } block

=head1 SYNOPSIS

	use Test::YAFT;

	override { Some::Module::function => sub { ... } };

	it q (should ...)
		=> override { Some::Module::function => sub { ... } }
		=> got      { ... }
		=> expect   => ...
		;

=head1 DESCRIPTION

Block is evaluated in list context and its result value (fully qualified
function name and coderef) is used to override the function behaviour
in the current scope.

The override works by calling the original function first, then calling
the provided coderef with the same arguments.

Uses L<Sub::Override> to handle the function replacement.

=head1 AUTHOR

Branislav Zahradník <barney@cpan.org>

=head1 COPYRIGHT AND LICENSE

This module is part of L<Test::YAFT> distribution.

=cut
