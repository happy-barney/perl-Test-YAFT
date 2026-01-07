#!/usr/bin/env perl

use v5.14;
use warnings;

use require::relative q (test-helper.pl);

assume_test_yaft_exports expect_instance_of
	=> by_default => 1
	=> on_demand  => 1
	=> by_tag     => [qw [all default expectations]]
	;

assume_yaft_dump q (Dumper should produce expect_instance_of)
	=> got { expect_instance_of (q (Foo)) }
	=> expect => <<'END_OF_EXPECTED'
expect_instance_of (
  'Foo',
)
END_OF_EXPECTED
	;

package Testing::Parent {
	sub new { bless +{ }, shift }
}

package Testing::Child {
	use parent -norequire => qw (Testing::Parent);
}

my $parent = Testing::Parent::->new;
my $child  = Testing::Child::->new;

check_test q (should pass when object is instance of exact class)
	=> assumption {
		it q (object is instance of Testing::Child)
			=> got    { Testing::Child::->new }
			=> expect { expect_instance_of (Testing::Child::) }
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (object is instance of Testing::Child)
	;

check_test q (should pass when object is instance of parent class)
	=> assumption {
		it q (object is instance of Testing::Parent)
			=> got    { Testing::Child::->new }
			=> expect { expect_instance_of (Testing::Parent::) }
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (object is instance of Testing::Parent)
	;

check_test q (should fail when object is not instance of class)
	=> assumption {
		it q (parent is not instance of child class)
			=> got    => $parent
			=> expect => expect_instance_of (Testing::Child::)
			;
	}
	=> ok          => 0,
	=> actual_ok   => 0,
	=> name        => q (parent is not instance of child class),
	=> diag        => <<'EXPECTED_DIAG',
+----+--------------------------------+----+----------------------+
| Elt|Got                             | Elt|Expected              |
+----+--------------------------------+----+----------------------+
*   0|bless( {}, 'Testing::Parent' )  *   0|expect_instance_of (  *
|    |                                *   1|  'Testing::Child',   *
|    |                                *   2|)                     *
+----+--------------------------------+----+----------------------+
Checking class of $data with isa()
   got : Testing::Parent=HASH(0x...)
expect : blessed into 'Testing::Child' or subclass of 'Testing::Child'
EXPECTED_DIAG
	;

check_test q (should fail with class name)
	=> assumption {
		it q (class name is not an instance)
			=> got    { Testing::Parent:: }
			=> expect => expect_instance_of (Testing::Parent::)
			;
	}
	=> ok          => 0
	=> actual_ok   => 0
	=> name        => q (class name is not an instance)
	=> diag        => <<'EXPECTED_DIAG'
+----+-------------------+----+----------------------+
| Elt|Got                | Elt|Expected              |
+----+-------------------+----+----------------------+
*   0|'Testing::Parent'  *   0|expect_instance_of (  *
|    |                   *   1|  'Testing::Parent',  *
|    |                   *   2|)                     *
+----+-------------------+----+----------------------+
Checking class of $data with isa()
   got : 'Testing::Parent'
expect : blessed into 'Testing::Parent' or subclass of 'Testing::Parent'
EXPECTED_DIAG
	;

check_test q (should fail with undef)
	=> assumption {
		it q (undef is not an instance)
			=> got    { undef }
			=> expect { expect_instance_of (Testing::Parent::) }
			;
	}
	=> ok          => 0
	=> actual_ok   => 0
	=> name        => q (undef is not an instance)
	=> diag        => <<'EXPECTED_DIAG',
+----+-------+----+----------------------+
| Elt|Got    | Elt|Expected              |
+----+-------+----+----------------------+
*   0|undef  *   0|expect_instance_of (  *
|    |       *   1|  'Testing::Parent',  *
|    |       *   2|)                     *
+----+-------+----+----------------------+
Checking class of $data with isa()
   got : undef
expect : blessed into 'Testing::Parent' or subclass of 'Testing::Parent'
EXPECTED_DIAG
	;

had_no_warnings;
done_testing;
