
use v5.14;
use warnings;

use Syntax::Construct qw (package-block package-version);

package Test::YAFT::Attributes {
	use Attribute::Handlers;

	use Ref::Util;

	my %where = (
		Exported   => q (EXPORT),
		Exportable => q (EXPORT_OK),
	);

	sub import {
		my $caller = scalar caller;
		my $target = __PACKAGE__;

		for my $attribute (qw[ Exported Exportable From Cmp_Builder ]) {
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

	sub _build_coderef {
		my ($package, $symbol, $referent, $attr, $data, $phase, $filename, $linenum) = @_;

		return
			unless $data
			;

		my ($builder) = @$data;

		if (Ref::Util::is_coderef ($builder)) {
			return $builder;
		}

		return eval qq (
			sub {
				${builder}->new (\@_)
			}
		);
	}

	sub _exported {
		my ($package, $symbol, $referent, $attr, $data, $phase, $filename, $linenum) = @_;

		my $where = $where{$attr};

		no strict q (refs);
		push @{qq (${package}::${where})}, &_symbol_name;
		push @{qq (${package}::EXPORT_OK)}, &_symbol_name
			if $where eq q (EXPORT)
			;

		push @{ ${qq (${package}::EXPORT_TAGS)}{$_} //= [] }, &_symbol_name
				for eval { @{ $data // [] } }
				;
	}

	sub _install_coderef {
		my ($package, $symbol, $referent, $attr, $data, $phase, $filename, $linenum) = @_;

		return
			unless my $coderef = &_build_coderef
			;

		*{$symbol} = $coderef;
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
