
use v5.14;
use warnings;

use Syntax::Construct qw (package-block package-version);

package Test::YAFT {
	use parent qw (Exporter::Tiny);

	use Context::Singleton;
	use Ref::Util qw ();
	use Safe::Isa qw ();
	use Scalar::Util qw ();
	use Sub::Install qw ();

	use Test::Deep qw ();
	use Test::Differences qw ();
	use Test::More     v0.970 qw ();

	require Test::Warnings;

	use Test::YAFT::Arrange;
	use Test::YAFT::Attributes;
	use Test::YAFT::Cmp;
	use Test::YAFT::Cmp::Compare;
	use Test::YAFT::Cmp::Complement;
	use Test::YAFT::Got;

	# v5.14 forward prototype declaration to prevent warnings from attributes
	sub act (&;@);
	sub arrange (&);
	sub got (&);
	sub pass (;$);

	sub act (&;@)                   :Exported(all,helpers);
	sub arrange (&)                 :Exported(all,helpers);
	sub assume                      :Exported(all,asserts)      :From(\&_test_yaft_assumption);
	sub BAIL_OUT                    :Exported(all,helpers)      :From(\&Test::More::BAIL_OUT);
	sub cmp_details                 :Exportable(all,plumbings)  :From(\&Test::Deep::cmp_details);
	sub deep_diag                   :Exportable(all,plumbings)  :From(\&Test::Deep::deep_diag);
	sub diag                        :Exported(all,helpers)      :From(\&Test::More::diag);
	sub done_testing                :Exported(all,helpers)      :From(\&Test::More::done_testing);
	sub eq_deeply                   :Exportable(all,plumbings)  :From(\&Test::Deep::eq_deeply);
	sub expect_all                  :Exported(all,expectations) :From(\&Test::Deep::all);
	sub expect_any                  :Exported(all,expectations) :From(\&Test::Deep::any);
	sub expect_array                :Exported(all,expectations) :From(\&Test::Deep::array);
	sub expect_array_each           :Exported(all,expectations) :From(\&Test::Deep::array_each);
	sub expect_array_elements_only  :Exported(all,expectations) :From(\&Test::Deep::arrayelementsonly);
	sub expect_array_length         :Exported(all,expectations) :From(\&Test::Deep::arraylength);
	sub expect_array_length_only    :Exported(all,expectations) :From(\&Test::Deep::arraylengthonly);
	sub expect_bag                  :Exported(all,expectations) :From(\&Test::Deep::bag);
	sub expect_blessed              :Exported(all,expectations) :From(\&Test::Deep::blessed);
	sub expect_bool                 :Exported(all,expectations) :From(\&Test::Deep::bool);
	sub expect_code                 :Exported(all,expectations) :From(\&Test::Deep::code);
	sub expect_compare              :Exported(all,expectations) :Cmp_Builder(Test::YAFT::Cmp::Compare);
	sub expect_complement           :Exported(all,expectations) :Cmp_Builder(Test::YAFT::Cmp::Complement);
	sub expect_false                :Exported(all,expectations);
	sub expect_hash                 :Exported(all,expectations) :From(\&Test::Deep::hash);
	sub expect_hash_each            :Exported(all,expectations) :From(\&Test::Deep::hash_each);
	sub expect_hash_keys            :Exported(all,expectations) :From(\&Test::Deep::hashkeys);
	sub expect_hash_keys_only       :Exported(all,expectations) :From(\&Test::Deep::hashkeysonly);
	sub expect_isa                  :Exported(all,expectations) :From(\&Test::Deep::Isa);
	sub expect_listmethods          :Exported(all,expectations) :From(\&Test::Deep::listmethods);
	sub expect_methods              :Exported(all,expectations) :From(\&Test::Deep::methods);
	sub expect_no_class             :Exported(all,expectations) :From(\&Test::Deep::noclass);
	sub expect_none                 :Exported(all,expectations) :From(\&Test::Deep::none);
	sub expect_none_of              :Exported(all,expectations) :From(\&Test::Deep::noneof);
	sub expect_num                  :Exported(all,expectations) :From(\&Test::Deep::num);
	sub expect_obj_isa              :Exported(all,expectations) :From(\&Test::Deep::obj_isa);
	sub expect_re                   :Exported(all,expectations) :From(\&Test::Deep::re);
	sub expect_ref_type             :Exported(all,expectations) :From(\&Test::Deep::reftype);
	sub expect_regexp_matches       :Exported(all,expectations) :From(\&Test::Deep::regexpmatches);
	sub expect_regexp_only          :Exported(all,expectations) :From(\&Test::Deep::regexponly);
	sub expect_regexpref            :Exported(all,expectations) :From(\&Test::Deep::regexpref);
	sub expect_regexpref_only       :Exported(all,expectations) :From(\&Test::Deep::regexprefonly);
	sub expect_scalarref            :Exported(all,expectations) :From(\&Test::Deep::scalref);
	sub expect_scalarref_only       :Exported(all,expectations) :From(\&Test::Deep::scalarrefonly);
	sub expect_set                  :Exported(all,expectations) :From(\&Test::Deep::set);
	sub expect_shallow              :Exported(all,expectations) :From(\&Test::Deep::shallow);
	sub expect_str                  :Exported(all,expectations) :From(\&Test::Deep::str);
	sub expect_subbag               :Exported(all,expectations) :From(\&Test::Deep::subbagof);
	sub expect_subbag_of            :Exported(all,expectations) :From(\&Test::Deep::subbagof);
	sub expect_subhash              :Exported(all,expectations) :From(\&Test::Deep::subhashof);
	sub expect_subhash_of           :Exported(all,expectations) :From(\&Test::Deep::subhashof);
	sub expect_subset               :Exported(all,expectations) :From(\&Test::Deep::subsetof);
	sub expect_subset_of            :Exported(all,expectations) :From(\&Test::Deep::subsetof);
	sub expect_superbag             :Exported(all,expectations) :From(\&Test::Deep::superbagof);
	sub expect_superbag_of          :Exported(all,expectations) :From(\&Test::Deep::superbagof);
	sub expect_superhash            :Exported(all,expectations) :From(\&Test::Deep::superhashof);
	sub expect_superhash_of         :Exported(all,expectations) :From(\&Test::Deep::superhashof);
	sub expect_superset             :Exported(all,expectations) :From(\&Test::Deep::supersetof);
	sub expect_superset_of          :Exported(all,expectations) :From(\&Test::Deep::supersetof);
	sub expect_true                 :Exported(all,expectations);
	sub expect_use_class            :Exported(all,asserts)      :From(\&Test::Deep::useclass);
	sub expect_value                :Exported(all,expectations) :Cmp_Builder(Test::YAFT::Cmp);
	sub explain                     :Exported(all,helpers)      :From(\&Test::More::explain);
	sub fail                        :Exported(all,asserts);
	sub got (&)                     :Exported(all,helpers);
	sub had_no_warnings             :Exported(all,asserts)      :From(\&Test::Warnings::had_no_warnings);
	sub ignore                      :Exported(all,expectations) :From(\&Test::Deep::ignore);
	sub it                          :Exported(all,asserts)      :From(\&_test_yaft_assumption);
	sub nok                         :Exported(all,asserts);
	sub note                        :Exported(all,helpers)      :From(\&Test::More::note);
	sub ok                          :Exported(all,asserts);
	sub pass (;$)                   :Exported(all,asserts)      :From(\&Test::More::pass);
	sub plan                        :Exported(all,helpers)      :From(\&Test::More::plan);
	sub skip                        :Exported(all,helpers)      :From(\&Test::More::skip);
	sub subtest                     :Exported(all,helpers);
	sub test_deep_cmp               :Exportable(all,plumbings);
	sub test_frame (&)              :Exportable(all,plumbings);
	sub there                       :Exported(all,asserts)      :From(\&_test_yaft_assumption);
	sub todo                        :Exported(all,helpers)      :From(\&Test::More::todo);
	sub todo_skip                   :Exported(all,helpers)      :From(\&Test::More::todo_skip);

	my $SINGLETON_ACT = q (Test::YAFT::act);

	sub _act_arrange;
	sub _act_dependencies;
	sub _act_singleton;
	sub _build_got;
	sub _run_act;
	sub _run_coderef;
	sub _run_diag;
	sub _test_yaft_assumption_args;

	sub _act_arrange {
		my ($args) = @_;

		proclaim $_->resolve
			for @{ $args->{arrange} // [] };

		proclaim s/^with_//r => $args->{$_}
			for grep m/^with_/, keys %$args;
	}

	sub _act_dependencies {
		my ($act, @dependencies) = @{ deduce $SINGLETON_ACT };

		return @dependencies;
	}

	sub _act_singleton {
		my ($act, @dependencies) = @{ deduce $SINGLETON_ACT };

		return $act;
	}

	sub _build_got {
		my ($args) = @_;

		return _run_act
			unless exists $args->{got};

		return _run_coderef ($args->{got})
			if Ref::Util::is_coderef ($args->{got});

		return +{
			lives_ok => 1,
			value    => $args->{got},
			error    => undef,
		};
	}

	sub _run_act {
		my ($act, @dependencies) = @{ deduce $SINGLETON_ACT };
		my @missing = grep { ! try_deduce $_ } @dependencies;

		return {
			lives_ok => 0,
			value    => undef,
			error    => qq (Act dependencies not fulfilled: ${\ join q (, ), sort @missing }),
		} if @missing;

		deduce _act_singleton;
	}

	sub _run_coderef {
		my ($builder, @args) = @_;

		my $result = { value => undef };
		$result->{lives_ok} = eval { $result->{value} = $builder->(@args); 1 };
		$result->{error} = $@;

		return $result;
	}

	sub _run_diag {
		my ($diag, $stack, $got) = @_;

		return
			unless $diag;

		return Test::More::diag ($diag->($stack, $got))
			if Ref::Util::is_coderef ($diag);

		return Test::More::diag (@$diag)
			if Ref::Util::is_arrayref ($diag);

		return Test::More::diag ($diag);
	}

	sub _test_yaft_assumption {
		my ($title, @args) = @_;

		my %args = _test_yaft_assumption_args @args;

		my ($ok, $stack, $got, $expect);
		test_frame {
			_act_arrange (\ %args);
			my $result = _build_got (\ %args);

			my $expected_to_live = ! exists $args{throws};

			return fail $title, diag => $expected_to_live
				? qq (Expected to live but died: $result->{error})
				: q  (Expected to die by lives)
				if $expected_to_live xor $result->{lives_ok}
				;

			($got, $expect) = $result->{lives_ok}
				? ($result->{value}, $args{expect})
				: ($result->{error}, $args{throws})
				;

			($ok, $stack) = Test::Deep::cmp_details ($got, $expect);

			return Test::More::ok ($ok, $title)
				if $ok
				|| defined $args{diag}
				|| $expect->$Safe::Isa::_isa (Test::Deep::Boolean::)
				;

			if ($expect->$Safe::Isa::_isa (Test::YAFT::Cmp::Complement::)) {
				Test::More::ok ($ok, $title);
				Test::More::diag (Test::Deep::deep_diag ($stack))
					unless $ok;
				return $ok;
			}

			Test::Differences::eq_or_diff $got, $expect, $title;
			Test::More::diag (Test::Deep::deep_diag ($stack))
				if ref $got || ref $expect;

			return;
		} or _run_diag ($args{diag}, $stack, $got);

		return $ok;
	}

	sub _test_yaft_assumption_args {
		my %args;

		while (@_) {
			if (Scalar::Util::blessed ($_[0])) {
				$args{got} = shift and next
					if $_[0]->isa (Test::YAFT::Got::);
				push @{ $args{arrange} //= [] }, shift and next
					if $_[0]->isa (Test::YAFT::Arrange::);
				die qq (Ref ${\ ref $_[0] } not recognized);
			}

			my ($key, $value) = splice @_, 0, 2;

			push @{ $args{arrange} //= [] }, Test::YAFT::Arrange::->new (sub { $value }) and next
				if $key eq q (arrange);

			$args{$key} = $value;
		}

		return %args;
	}

	sub act (&;@) {
		my ($act, @dependencies) = @_;
		state $counter = 0;

		# As far as Context::Singleton doesn't support frame local contrive (yet)
		# we have to improvise
		# - singleton 'Test::YAFT::act' will contain name of frame specific singleton
		# - and that singleton will contain all dependencies

		my $singleton = qq (${SINGLETON_ACT}::${\ ++$counter });

		contrive $singleton
			=> dep => \@dependencies
			=> as  => sub { _run_coderef ($act, @_) }
			;

		proclaim $SINGLETON_ACT => [ $singleton, @dependencies ];
	}

	sub arrange (&) {
		return Test::YAFT::Arrange::->new (@_);
	}

	sub expect_false {
		Test::Deep::bool (0);
	}

	sub expect_true {
		Test::Deep::bool (1);
	}

	sub fail {
		my ($title, %args) = @_;

		test_frame {
			_test_yaft_assumption $title,
				diag => q (),
				%args,
				got => 0,
				expect => expect_true,
				;
		}
	}

	sub got (&) {
		Test::YAFT::Got->new (@_);
	}

	sub nok {
		my ($message, %args) = @_;

		test_frame {
			_test_yaft_assumption $message,
				%args,
				expect => expect_false,
				diag   => q (),
				;
		}
	}

	sub ok {
		my ($message, %args) = @_;

		test_frame {
			_test_yaft_assumption $message,
				%args,
				expect => expect_true,
				diag   => q (),
				;
		}
	}

	sub subtest {
		my ($title, $code) = @_;

		test_frame {
			Test::More::subtest $title, $code;
		};
	}

	sub test_deep_cmp {
		my (%methods) = @_;

		state $serial = 0;
		my $prefix = q (Test::Deep::Cmp::__ANON__::);

		my $class = $prefix . ++$serial;
		my $isa = delete $methods{isa} // q (Test::YAFT::Cmp);

		{
			my @isa = Ref::Util::is_arrayref ($isa) ? @$isa : ($isa);
			eval qq (require $_) for @isa;

			no strict q (refs);
			@{ qq ($class\::ISA) } = @isa;
		}

		Sub::Install::install_sub ({ into => $class, as => $_, code => $methods{$_} })
			for keys %methods;

		return $class;
	}

	sub test_frame (&) {
		my ($code) = @_;

		# 1 - caller sub context
		# 2 - this sub context
		# 3 - frame
		# 4 - code arg context
		local $Test::Builder::Level = $Test::Builder::Level + 4;

		&frame ($code);
	}

	1;
};
