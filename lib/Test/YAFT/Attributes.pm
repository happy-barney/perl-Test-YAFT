
use v5.14;
use warnings;

use Syntax::Construct qw (package-block package-version);

package Test::YAFT::Attributes {
	use Attribute::Handlers;

	my %where = (
		Exported => q (EXPORT),
		Exportable => q (EXPORT_OK),
	);

	sub import {
		my $caller = scalar caller;
		my $target = __PACKAGE__;

		for my $attribute (qw[ Exported Exportable From Cmp_Builder ]) {
			eval qq (sub ${caller}::${attribute} : ATTR(CODE,BEGIN) { goto &${target}::${attribute} });
			die qq (cannot install $target attribute $attribute in $caller: $@) if $@;
		}
	}

	sub _exported {
		my ($package, $symbol, $referent, $attr, $data, $phase, $filename, $linenum) = @_;

		my $where = $where{$attr};

		no strict q (refs);
		push @{qq (${package}::$where)}, *{$symbol}{NAME};
		if ($data) {
			push @{ ${qq (${package}::EXPORT_TAGS)}{$_} //= [] }, *{$symbol}{NAME} for eval { @$data };
		}
	}

	sub Exported {
		goto &_exported;
	}

	sub Exportable {
		goto &_exported;
	}

	sub From {
		my ($package, $symbol, $referent, $attr, $data, $phase, $filename, $linenum) = @_;

		if (ref $data->[0] eq q (CODE)) {
			my $function = shift @$data;
			*{$symbol} = $function;
		}
	}

	sub Cmp_Builder {
		my ($package, $symbol, $referent, $attr, $data, $phase, $filename, $linenum) = @_;

		my $class = ref ($data)
			? $data->[0]
			: $data
			;

		*{$symbol} = eval qq (sub { $class->new (\@_) });
	}

	1;
}
