#!/usr/bin/env perl

use v5.14;
use warnings;

use Test::Load::Helper;

use Test::YAFT::Act;

sub build_act {
	Test::YAFT::Act::->new (@_);
}

my $act_coderef = sub { };

it q (accepts stringy act without arguments)
	=> got    { build_act (q (act-name)) }
	=> expect =>
		+ expect_methods     (act          => q (act-name))
		+ expect_listmethods (dependencies => [ ])
	;

it q (accepts string act with some arguments)
	=> got    { build_act (q (act-name), qw (arg-1 arg-2)) }
	=> expect =>
		+ expect_methods     (act          => q (act-name))
		+ expect_listmethods (dependencies => [qw (arg-1 arg-2)])
	;

it q (accepts coderef act without arguments)
	=> got    { build_act ($act_coderef) }
	=> expect =>
		+ expect_methods     (act          => expect_shallow ($act_coderef))
		+ expect_listmethods (dependencies => [ ])
	;

it q (accepts coderef act with some arguments)
	=> got    { build_act ($act_coderef, qw (arg-1 arg-2)) }
	=> expect =>
		+ expect_methods     (act          => expect_shallow ($act_coderef))
		+ expect_listmethods (dependencies => [qw (arg-1 arg-2)])
	;

had_no_warnings;
done_testing;
