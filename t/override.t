#!/usr/bin/env perl

use v5.14;
use warnings;

use require::relative q (test-helper.pl);

use Test::YAFT::Argument::Override;

assume_test_yaft_exports override
	=> by_default => 1
	=> on_demand  => 1
	=> by_tag     => [qw [all default utils helpers]]
	;

sub expect_plain_coderef;
sub expect_coderef_returns;

subtest q (_decode_override_code ()) => sub {
	act {
		my ($args) = @_;
		Test::YAFT::Argument::Override::->_decode_override_code (@$args);
	}
		q (args)
		;

	my $test_code = sub { q (test) };

	assume q (when given a plain coderef returns it)
		=> with_args => [ $test_code ],
		=> expect    =>
			& expect_value ($test_code)
			& expect_coderef_return (q (value))
		;

	assume q (wraps non-coderef value in a coderef)
		=> got    { ref Test::YAFT::Argument::Override::->_decode_override_code (q (value)) }
		=> expect { q (CODE) }
		;

	assume q (wrapped coderef returns the scalar value)
		=> got    { Test::YAFT::Argument::Override::->_decode_override_code (q (value))->() }
		=> expect { q (value) }
		;

	assume q (pops last element of spec as the code argument)
		=> got    { Test::YAFT::Argument::Override::->_decode_override_code (q (ignored), q (value))->() }
		=> expect { q (value) }
		;
};

subtest q (_decode_override_function ()) => sub {
	act { Test::YAFT::Argument::Override::->_decode_override_function (@{$_[0]}) }
		q (spec),
		;

	assume q (two-element spec: returns qualified name as-is)
		=> with_spec => [q (Testing::Override::foo), sub {}]
		=> expect    { q (Testing::Override::foo) }
		;

	assume q (three-element spec: returns second element when it contains ::)
		=> with_spec => [q (Testing::Override), q (Testing::Override::foo), sub {}]
		=> expect    { q (Testing::Override::foo) }
		;

	assume q (three-element spec: combines package and function name)
		=> with_spec => [q (Testing::Override), q (foo), sub {}]
		=> expect    { q (Testing::Override::foo) }
		;

	assume q (three-element spec: strips trailing :: from package name)
		=> with_spec => [q (Testing::Override::), q (foo), sub {}]
		=> expect    { q (Testing::Override::foo) }
		;

	assume q (three-element spec: extracts class name from blessed object)
		=> with_spec => [bless ({}, q (Testing::Override)), q (foo), sub {}]
		=> expect    { q (Testing::Override::foo) }
		;

	assume q (three-element spec: blessed object with qualified name ignores object)
		=> with_spec => [bless ({}, q (Testing::Override)), q (Testing::Override::foo), sub {}]
		=> expect    { q (Testing::Override::foo) }
		;
};

subtest q (code override) => sub {
	override { q (Testing::Override::foo) => sub { q (current-override) } };

	assume q (function is overridden in current scope)
		=> got    { Testing::Override::foo () }
		=> expect { q (current-override) }
		;

	assume q (function is further overridden in nested scope)
		=> override { q (Testing::Override::foo) => sub { q (local-override) } }
		=> got      { Testing::Override::foo () }
		=> expect   { q (local-override) }
		;

	assume q (nested override is gone after its scope ends)
		=> got    { Testing::Override::foo () }
		=> expect { q (current-override) }
		;
};

subtest q (value override) => sub {
	override { q (Testing::Override::foo) => q (value-override) };

	assume q (function is overridden with scalar value)
		=> got    { Testing::Override::foo () }
		=> expect { q (value-override) }
		;
};

subtest q (override with original::function) => sub {
	override { q (Testing::Override::foo) => sub { original::function () . q (/current-override) } };

	assume q (original::function calls the original function)
		=> got    { Testing::Override::foo () }
		=> expect { q (foo/current-override) }
		;

	assume q (nested: original::function refers to the outer override)
		=> override { q (Testing::Override::foo) => sub { original::function () . q (/local-override) } }
		=> got      { Testing::Override::foo () }
		=> expect   { q (foo/current-override/local-override) }
		;
};

subtest q (override with original::method) => sub {
	override { q (Testing::Override::foo) => sub { Testing::Override::->original::method . q (/current-override) } };

	assume q (original::method calls the original method on class)
		=> got    { Testing::Override::->foo }
		=> expect { q (foo/current-override) }
		;

	assume q (nested: original::method refers to the outer override)
		=> override { q (Testing::Override::foo) => sub { Testing::Override::->original::method . q (/local-override) } }
		=> got      { Testing::Override::->foo }
		=> expect   { q (foo/current-override/local-override) }
		;

	assume q (original::method works on a blessed instance)
		=> override { q (Testing::Override::foo) => sub { $_[0]->original::method . q (/instance-override) } }
		=> got      { do { my $obj = bless {}, Testing::Override::; $obj->foo } }
		=> expect   { q (foo/instance-override) }
		;
};

subtest q (override inherited method) => sub {
	override { q (Testing::Override::Child::foo) => sub { original::function () . q (/child-override) } };

	assume q (original::function resolves to parent implementation)
		=> got    { Testing::Override::Child::->foo }
		=> expect { q (foo/child-override) }
		;

	assume q (original::method resolves to parent implementation)
		=> override { q (Testing::Override::Child::foo) => sub { $_[0]->original::method . q (/child-override) } }
		=> got      { do { my $obj = bless {}, Testing::Override::Child::; $obj->foo } }
		=> expect   { q (foo/child-override) }
		;
};

subtest q (override non-existing function) => sub {
	assume q (function is injected when it did not exist)
		=> override { q (Testing::Override::non_existing) => sub { q (injected) } }
		=> got      { Testing::Override::->non_existing }
		=> expect   { q (injected) }
		;

	assume q (injected function is gone after scope ends)
		=> got    { Testing::Override::->can (q (non_existing)) }
		=> expect { undef }
		;
};

subtest q (object override) => sub {
	my $foo = bless {}, Testing::Override::;
	my $bar = bless {}, Testing::Override::;

	override { $bar => foo => q (bar) };

	assume q (method is overridden only for bar object)
		=> got    { $bar->foo }
		=> expect { q (bar) }
		;

	assume q (foo object uses original function)
		=> got    { $foo->foo }
		=> expect { q (foo) }
		;
};

subtest q (arrayref syntax - 1 element) => sub {
	assume q (1-element arrayref is equivalent to plain qualified name)
		=> override { [q (Testing::Override::foo)] => sub { q (arrayref-1-override) } }
		=> got      { Testing::Override::foo () }
		=> expect   { q (arrayref-1-override) }
		;
};

subtest q (arrayref syntax - 2 elements) => sub {
	my $bar = bless {}, Testing::Override::;

	assume q (2-element arrayref overrides only the matching instance)
		=> override { [$bar, q (foo)] => q (arrayref-2-override) }
		=> got      { $bar->foo }
		=> expect   { q (arrayref-2-override) }
		;
};

subtest q (arrayref syntax - 3 elements) => sub {
	my $bar = bless {}, Testing::Override::;

	assume q (3-element arrayref is self-contained)
		=> override { [$bar, q (foo), q (arrayref-3-override)] }
		=> got      { $bar->foo }
		=> expect   { q (arrayref-3-override) }
		;
};

assume q (override is gone after all scopes end)
	=> got    { Testing::Override::foo () }
	=> expect { q (foo) }
	;

had_no_warnings;
done_testing;

package Testing::Override {
	sub foo {
		return q (foo);
	}
}

package Testing::Override::Child {
	use parent q (Testing::Override);
}

package Testing::Override::Inherit {
	sub bar {
		return q (bar);
	}
}
