#!/usr/bin/env perl

use v5.14;
use warnings;

use require::relative q (test-helper.pl);

assume_test_yaft_exports expect_blessed_to
	=> by_default => 1
	=> on_demand  => 1
	=> by_tag     => [qw [all default expectations]]
	;

assume_yaft_dump q (Dumper should serialize 'expect_blessed_to' call)
	=> got { expect_blessed_to (q (Foo)) }
	=> expect => <<'END_OF_EXPECTED'
expect_blessed_to (
  'Foo',
)
END_OF_EXPECTED
	;

package Testing::Parent {
	sub new {
		return bless {}, shift;
	}
}

package Testing::Child {
	use parent -norequire => qw (Testing::Parent);
}

check_test q (successful validation with object blessed to expected class)
	=> assumption {
		it q (should pass with blessed object)
			=> got    => Testing::Child::->new
			=> expect => expect_blessed_to (Testing::Child::)
			;
	}
	=> ok          => 1,
	=> actual_ok   => 1,
	=> name        => q (should pass with blessed object),
	;

check_test q (failed validation with object blessed to child class)
	=> assumption {
		it q (should fail with an instance of child class)
			=> got    => Testing::Child::->new
			=> expect => expect_blessed_to (Testing::Parent::)
			;
	}
	=> ok          => 0,
	=> actual_ok   => 0,
	=> name        => q (should fail with an instance of child class),
	=> diag        => <<'END_OF_DIAG'
+----+-------------------------------+----+----------------------+
| Elt|Got                            | Elt|Expected              |
+----+-------------------------------+----+----------------------+
*   0|bless( {}, 'Testing::Child' )  *   0|expect_blessed_to (   *
|    |                               *   1|  'Testing::Parent',  *
|    |                               *   2|)                     *
+----+-------------------------------+----+----------------------+
Compared blessed($data)
   got : 'Testing::Child'
expect : 'Testing::Parent'
END_OF_DIAG
	;

check_test q (failed validation without an object)
	=> assumption {
		it q (should fail without an object)
			=> got    => Testing::Child::
			=> expect => expect_blessed_to (Testing::Child::)
			;
	}
	=> ok          => 0,
	=> actual_ok   => 0,
	=> name        => q (should fail without an object),
	=> diag        => <<'END_OF_DIAG'
+----+------------------+----+---------------------+
| Elt|Got               | Elt|Expected             |
+----+------------------+----+---------------------+
*   0|'Testing::Child'  *   0|expect_blessed_to (  *
|    |                  *   1|  'Testing::Child',  *
|    |                  *   2|)                    *
+----+------------------+----+---------------------+
Compared blessed($data)
   got : undef
expect : 'Testing::Child'
END_OF_DIAG
	;

had_no_warnings;
done_testing;
