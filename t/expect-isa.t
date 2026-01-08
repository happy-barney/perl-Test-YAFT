#!/usr/bin/env perl

use v5.14;
use warnings;

use require::relative q (test-helper.pl);

assume_test_yaft_exports expect_isa
	=> by_default => 1
	=> on_demand  => 1
	=> by_tag     => [qw [all default expectations]]
	;

assume_yaft_dump q (Dumper should produce expect_isa (q (Foo)))
	=> got { expect_isa (q (Foo)) }
	=> expect => <<'END_OF_EXPECTED'
expect_isa (
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

	sub new {
		return bless {}, shift;
	}
}

check_test q (pass with instance of expected class)
	=> assumption {
		it q (object is instance of Testing::Parent)
			=> got    { Testing::Parent::->new }
			=> expect { expect_isa (Testing::Parent::) }
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (object is instance of Testing::Parent)
	;

check_test q (pass with instance of child class when parent expected)
	=> assumption {
		it q (child object is instance of parent class)
			=> got    { Testing::Child::->new }
			=> expect { expect_isa (Testing::Parent::) }
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (child object is instance of parent class)
	;

check_test q (fail with class)
	=> assumption {
		it q (class name string is not an instance)
			=> got    { Testing::Parent:: }
			=> expect { expect_isa (Testing::Parent::) }
			;
	}
	=> ok          => 0
	=> actual_ok   => 0
	=> name        => q (class name string is not an instance)
	=> diag        => <<'END_OF_DIAG'
+----+-------------------+----+----------------------+
| Elt|Got                | Elt|Expected              |
+----+-------------------+----+----------------------+
*   0|'Testing::Parent'  *   0|expect_isa (          *
|    |                   *   1|  'Testing::Parent',  *
|    |                   *   2|)                     *
+----+-------------------+----+----------------------+
Checking class of $data with isa()
   got : 'Testing::Parent'
expect : blessed into or ref of type 'Testing::Parent'
END_OF_DIAG
	;

check_test q (fail with parent when child expected)
	=> assumption {
		it q (parent is not instance of child class)
			=> got    { Testing::Parent::->new }
			=> expect { expect_isa (Testing::Child::) }
			;
	}
	=> ok          => 0
	=> actual_ok   => 0
	=> name        => q (parent is not instance of child class)
	=> diag        => <<'END_OF_DIAG'
+----+--------------------------------+----+---------------------+
| Elt|Got                             | Elt|Expected             |
+----+--------------------------------+----+---------------------+
*   0|bless( {}, 'Testing::Parent' )  *   0|expect_isa (         *
|    |                                *   1|  'Testing::Child',  *
|    |                                *   2|)                    *
+----+--------------------------------+----+---------------------+
Checking class of $data with isa()
   got : Testing::Parent=HASH(0x...)
expect : blessed into or ref of type 'Testing::Child'
END_OF_DIAG
	;

check_test q (pass with unblessed hash reference)
	=> assumption {
		it q (hash reference matches HASH type)
			=> got    => {}
			=> expect => expect_isa (q (HASH))
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (hash reference matches HASH type)
	;

had_no_warnings;
done_testing;
