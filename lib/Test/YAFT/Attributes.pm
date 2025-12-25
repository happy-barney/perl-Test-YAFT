
use v5.14;
use warnings;

use Syntax::Construct qw (package-block package-version);

package Test::YAFT::Attributes {
	use Attribute::Handlers;

	require Ref::Util;
	require Sub::Util;

	my %attributes = (
		Exported    => q (EXPORT),
		Exportable  => q (EXPORT_OK),
		From        => undef,
		Cmp_Builder => undef,
	);

	sub import {
		my $caller = scalar caller;
		my $target = __PACKAGE__;

		for my $attribute (keys %attributes) {
			eval qq (
				sub ${caller}::${attribute} : ATTR(CODE,BEGIN) {
					goto &${target}::${attribute}
				}
			);

			die qq (cannot install ${target} attribute ${attribute} into ${caller}: $@)
				if $@
				;
		}
	}

	sub _push_unique_string (\@;@);

	sub _build_coderef {
		my ($package, $symbol, $referent, $attr, $data, $phase, $filename, $linenum) = @_;

		return
			unless $data
			;

		my ($builder, @arguments) = @$data;

		if (Ref::Util::is_coderef ($builder)) {
			return sub { $builder->(@arguments, @_) }
				if @arguments
				|| _is_distinct_prototype ($referent, $builder)
				;

			return $builder;
		}

		return sub { $builder->new (@arguments, @_) };
	}

	sub _exported {
		my ($package, $symbol, $referent, $attr, $data, $phase, $filename, $linenum) = @_;

		my $where = $attributes{$attr};

		no strict q (refs);
		_push_unique_string @{qq (${package}::${where})}, &_symbol_name;
		_push_unique_string @{qq (${package}::EXPORT_OK)}, &_symbol_name;

		_push_unique_string @{ ${qq (${package}::EXPORT_TAGS)}{$_} //= [] }, &_symbol_name
				for eval { @{ $data // [] } }
				;
	}

	sub _install_coderef {
		my ($package, $symbol, $referent, $attr, $data, $phase, $filename, $linenum) = @_;

		return
			unless my $coderef = &_build_coderef
			;

		if (defined (my $prototype = Sub::Util::prototype ($referent))) {
			Sub::Util::set_prototype $prototype => $coderef;
		}

		*{$symbol} = $coderef;
	}

	sub _is_distinct_prototype {
		my ($target, $source) = @_;

		my $lhs = Sub::Util::prototype ($target);
		my $rhs = Sub::Util::prototype ($source);

		return 0
			|| (defined $lhs xor defined $rhs)
			|| (defined $lhs && $lhs ne $rhs)
			;
	}

	sub _push_unique_string (\@;@) {
		my $push_into = shift;

		my %exists;
		@exists{@$push_into} = ();

		push @$push_into, grep { ! exists $exists{$_} } @_;
	}

	sub _symbol_name {
		my ($package, $symbol, $referent, $attr, $data, $phase, $filename, $linenum) = @_;

		*{$symbol}{NAME};
	}

	sub Exported {
		goto &_exported;
	}

	sub Exportable {
		goto &_exported;
	}

	sub From {
		my ($package, $symbol, $referent, $attr, $data, $phase, $filename, $linenum) = @_;

		&_install_coderef;
	}

	sub Cmp_Builder {
		my ($package, $symbol, $referent, $attr, $data, $phase, $filename, $linenum) = @_;

		&_install_coderef;
	}

	1;
}
