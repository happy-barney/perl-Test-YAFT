#!/usr/bin/env perl

use v5.14;
use warnings;

use require::relative q (test-helper.pl);

assume_test_yaft_exports expect_can
	=> by_default => 1
	=> on_demand  => 1
	=> by_tag     => [qw [all default expectations]]
	;

assume_yaft_dump q (Dumper should serialize 'expect_can' call)
	=> got { expect_can (qw (foo bar)) }
	=> expect => <<'END_OF_EXPECTED'
expect_can (
  'foo',
  'bar',
)
END_OF_EXPECTED
	;

package Testing::Parent {
	sub new {
		bless {}, shift;
	}

	sub parent_method { }
}

package Testing::Class {
	use parent -norequire => qw (Testing::Parent);

	sub abstract;
	sub another_method { }
	sub method { }
}

package Testing::Can {
	use parent -norequire => qw (Testing::Class);

	sub can {
		my ($self, $method) = @_;

		return $_
			if local $_ = $self->SUPER::can ($method)
			;

		return $method =~ qr (^set_)
			? sub { }
			: undef
			;
	}
}

subtest q (with class name) => sub {
	check_test q (should pass when class can do single method)
		=> assumption {
			it q (should just pass)
				=> got    => Testing::Class::
				=> expect => expect_can qw (method)
				;
		}
		=> ok          => 1,
		=> actual_ok   => 1,
		=> name        => q (should just pass),
		;

	check_test q (should pass when class can do multiple methods)
		=> assumption {
			it q (should just pass)
				=> got    => Testing::Class::
				=> expect => expect_can qw (method another_method)
				;
		}
		=> ok          => 1,
		=> actual_ok   => 1,
		=> name        => q (should just pass),
		;

	check_test q (should pass when class can do inherited method)
		=> assumption {
			it q (should just pass)
				=> got    => Testing::Class::
				=> expect => expect_can qw (parent_method)
				;
		}
		=> ok          => 1,
		=> actual_ok   => 1,
		=> name        => q (should just pass),
		;

	check_test q (should pass when class provides its own can)
		=> assumption {
			it q (should just pass)
				=> got    => Testing::Can::
				=> expect => expect_can qw (method set_name)
				;
		}
		=> ok          => 1,
		=> actual_ok   => 1,
		=> name        => q (should just pass),
		;

	check_test q (should fail when class cannot do single method)
		=> assumption {
			it q (should just fail)
				=> got    => Testing::Class::
				=> expect => expect_can q (missing)
				;
		}
		=> ok          => 0,
		=> actual_ok   => 0,
		=> name        => q (should just fail),
		=> diag        => <<'EXPECTED_DIAG',
+----+------------------+----+--------------+
| Elt|Got               | Elt|Expected      |
+----+------------------+----+--------------+
*   0|'Testing::Class'  *   0|expect_can (  *
|    |                  *   1|  'missing',  *
|    |                  *   2|)             *
+----+------------------+----+--------------+
Check whether 'Testing::Class' 'can' method:
    [ ] missing
EXPECTED_DIAG
		;

	check_test q (should fail when class provides abstract method)
		=> assumption {
			it q (should just fail)
				=> got    => Testing::Class::
				=> expect => expect_can q (abstract)
				;
		}
		=> ok          => 0,
		=> actual_ok   => 0,
		=> name        => q (should just fail),
		=> diag        => <<'EXPECTED_DIAG',
+----+------------------+----+---------------+
| Elt|Got               | Elt|Expected       |
+----+------------------+----+---------------+
*   0|'Testing::Class'  *   0|expect_can (   *
|    |                  *   1|  'abstract',  *
|    |                  *   2|)              *
+----+------------------+----+---------------+
Check whether 'Testing::Class' 'can' method:
    [-] abstract
EXPECTED_DIAG
		;

	check_test q (should fail when class can do some but not all methods)
		=> assumption {
			it q (should just fail)
				=> got    => Testing::Can::
				=> expect => expect_can qw (missing method)
				;
		}
		=> ok          => 0,
		=> actual_ok   => 0,
		=> name        => q (should just fail),
		=> diag        => <<'EXPECTED_DIAG',
+----+----------------+----+--------------+
| Elt|Got             | Elt|Expected      |
+----+----------------+----+--------------+
*   0|'Testing::Can'  *   0|expect_can (  *
|    |                *   1|  'missing',  *
|    |                *   2|  'method',   *
|    |                *   3|)             *
+----+----------------+----+--------------+
Check whether 'Testing::Can' 'can' methods:
    [x] method
    [ ] missing
EXPECTED_DIAG
		;

	check_test q (should fail when called with no methods)
		=> assumption {
			it q (should just pass)
				=> got    => Testing::Class::
				=> expect => expect_can
				;
		}
		=> ok          => 0,
		=> actual_ok   => 0,
		=> name        => q (should just pass),
		=> diag        => <<'EXPECTED_DIAG',
+----+------------------+---------------+
| Elt|Got               |Expected       |
+----+------------------+---------------+
*   0|'Testing::Class'  |expect_can ()  *
+----+------------------+---------------+
expect_can () called with no method
EXPECTED_DIAG
		;
};

subtest q (with class instance) => sub {
	check_test q (should pass when class can do single method)
		=> assumption {
			it q (should just pass)
				=> got    => Testing::Class::->new
				=> expect => expect_can qw (method)
				;
		}
		=> ok          => 1,
		=> actual_ok   => 1,
		=> name        => q (should just pass),
		;

	check_test q (should pass when class can do multiple methods)
		=> assumption {
			it q (should just pass)
				=> got    => Testing::Class::->new
				=> expect => expect_can qw (method another_method)
				;
		}
		=> ok          => 1,
		=> actual_ok   => 1,
		=> name        => q (should just pass),
		;

	check_test q (should pass when class can do inherited method)
		=> assumption {
			it q (should just pass)
				=> got    => Testing::Class::->new
				=> expect => expect_can qw (parent_method)
				;
		}
		=> ok          => 1,
		=> actual_ok   => 1,
		=> name        => q (should just pass),
		;

	check_test q (should pass when class provides its own can)
		=> assumption {
			it q (should just pass)
				=> got    => Testing::Can::->new
				=> expect => expect_can qw (method set_name)
				;
		}
		=> ok          => 1,
		=> actual_ok   => 1,
		=> name        => q (should just pass),
		;

	check_test q (should fail when class cannot do single method)
		=> assumption {
			it q (should just fail)
				=> got    => Testing::Class::->new
				=> expect => expect_can q (missing)
				;
		}
		=> ok          => 0,
		=> actual_ok   => 0,
		=> name        => q (should just fail),
		=> diag        => <<'EXPECTED_DIAG',
+----+-------------------------------+----+--------------+
| Elt|Got                            | Elt|Expected      |
+----+-------------------------------+----+--------------+
*   0|bless( {}, 'Testing::Class' )  *   0|expect_can (  *
|    |                               *   1|  'missing',  *
|    |                               *   2|)             *
+----+-------------------------------+----+--------------+
Check whether Testing::Class=HASH(0x...) 'can' method:
    [ ] missing
EXPECTED_DIAG
		;

	check_test q (should fail when class can do some but not all methods)
		=> assumption {
			it q (should just fail)
				=> got    => Testing::Can::->new
				=> expect => expect_can qw (missing method)
				;
		}
		=> ok          => 0,
		=> actual_ok   => 0,
		=> name        => q (should just fail),
		=> diag        => <<'EXPECTED_DIAG',
+----+-----------------------------+----+--------------+
| Elt|Got                          | Elt|Expected      |
+----+-----------------------------+----+--------------+
*   0|bless( {}, 'Testing::Can' )  *   0|expect_can (  *
|    |                             *   1|  'missing',  *
|    |                             *   2|  'method',   *
|    |                             *   3|)             *
+----+-----------------------------+----+--------------+
Check whether Testing::Can=HASH(0x...) 'can' methods:
    [x] method
    [ ] missing
EXPECTED_DIAG
		;

	check_test q (should fail when called with no methods)
		=> assumption {
			it q (should just pass)
				=> got    => Testing::Class::->new
				=> expect => expect_can
				;
		}
		=> ok          => 0,
		=> actual_ok   => 0,
		=> name        => q (should just pass),
		=> diag        => <<'EXPECTED_DIAG',
+----+-------------------------------+---------------+
| Elt|Got                            |Expected       |
+----+-------------------------------+---------------+
*   0|bless( {}, 'Testing::Class' )  |expect_can ()  *
+----+-------------------------------+---------------+
expect_can () called with no method
EXPECTED_DIAG
		;
};

subtest q (when non-class) => sub {
	check_test q (should fail with literal 'undef')
		=> assumption {
			it q (should just fail)
				=> got    { undef }
				=> expect => expect_can q (method)
				;
		}
		=> ok          => 0,
		=> actual_ok   => 0,
		=> name        => q (should just fail),
		=> diag        => <<'EXPECTED_DIAG',
+----+-------+----+--------------+
| Elt|Got    | Elt|Expected      |
+----+-------+----+--------------+
*   0|undef  *   0|expect_can (  *
|    |       *   1|  'method',   *
|    |       *   2|)             *
+----+-------+----+--------------+
Check whether undef 'can' method:
    [ ] method
EXPECTED_DIAG
		;

	check_test q (should fail with literal number)
		=> assumption {
			it q (should just fail)
				=> got    => 42
				=> expect => expect_can q (method)
				;
		}
		=> ok          => 0,
		=> actual_ok   => 0,
		=> name        => q (should just fail),
		=> diag        => <<'EXPECTED_DIAG',
+----+-----+----+--------------+
| Elt|Got  | Elt|Expected      |
+----+-----+----+--------------+
*   0|42   *   0|expect_can (  *
|    |     *   1|  'method',   *
|    |     *   2|)             *
+----+-----+----+--------------+
Check whether '42' 'can' method:
    [ ] method
EXPECTED_DIAG
		;

	check_test q (should fail with empty string and one method)
		=> assumption {
			it q (should just fail)
				=> got    => q ()
				=> expect => expect_can q (method)
				;
		}
		=> ok          => 0,
		=> actual_ok   => 0,
		=> name        => q (should just fail),
		=> diag        => <<'EXPECTED_DIAG',
+----+-----+----+--------------+
| Elt|Got  | Elt|Expected      |
+----+-----+----+--------------+
*   0|''   *   0|expect_can (  *
|    |     *   1|  'method',   *
|    |     *   2|)             *
+----+-----+----+--------------+
Check whether '' 'can' method:
    [ ] method
EXPECTED_DIAG
		;

	check_test q (should fail with unblessed arrayref)
		=> assumption {
			it q (should just fail)
				=> got    => [ ]
				=> expect => expect_can q (method)
				;
		}
		=> ok          => 0,
		=> actual_ok   => 0,
		=> name        => q (should just fail),
		=> diag        => <<'EXPECTED_DIAG',
+----+-----+----+--------------+
| Elt|Got  | Elt|Expected      |
+----+-----+----+--------------+
*   0|[]   *   0|expect_can (  *
|    |     *   1|  'method',   *
|    |     *   2|)             *
+----+-----+----+--------------+
Check whether ARRAY(0x...) 'can' method:
    [ ] method
EXPECTED_DIAG
		;

	check_test q (should fail with unblessed hashref)
		=> assumption {
			it q (should just fail)
				=> got    => { }
				=> expect => expect_can q (method)
				;
		}
		=> ok          => 0,
		=> actual_ok   => 0,
		=> name        => q (should just fail),
		=> diag        => <<'EXPECTED_DIAG',
+----+-----+----+--------------+
| Elt|Got  | Elt|Expected      |
+----+-----+----+--------------+
*   0|{}   *   0|expect_can (  *
|    |     *   1|  'method',   *
|    |     *   2|)             *
+----+-----+----+--------------+
Check whether HASH(0x...) 'can' method:
    [ ] method
EXPECTED_DIAG
		;
};

had_no_warnings;
done_testing;
