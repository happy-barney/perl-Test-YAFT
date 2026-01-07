#!/usr/bin/env perl

use v5.14;
use warnings;

use require::relative q (test-helper.pl);

assume_test_yaft_exports expect_does
	=> by_default => 1
	=> on_demand  => 1
	=> by_tag     => [qw [all default expectations]]
	;

assume_yaft_dump q (Dumper should produce expect_does)
	=> got { expect_does (q (Foo)) }
	=> expect => <<'END_OF_EXPECTED'
expect_does (
  'Foo',
)
END_OF_EXPECTED
	;

package Testing::Role {
	sub does_role { 1 }
}

package Testing::Consumer {
	sub new { bless +{ }, shift }

	sub DOES {
		my ($self, $role) = @_;

		$role eq q (Testing::Role) || $self->SUPER::DOES ($role);
	}
}

package Testing::Non_Consumer {
	sub new { bless +{ }, shift }
}

my $consumer     = Testing::Consumer::->new;
my $non_consumer = Testing::Non_Consumer::->new;

check_test q (should pass when object performs role)
	=> assumption {
		it q (object performs Testing::Role)
			=> got    { Testing::Consumer::->new }
			=> expect { expect_does (q (Testing::Role)) }
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (object performs Testing::Role)
	;

check_test q (should fail when object does not perform role)
	=> assumption {
		it q (object does not perform Testing::Role)
			=> got    => $non_consumer
			=> expect => expect_does (q (Testing::Role))
			;
	}
	=> ok          => 0
	=> actual_ok   => 0
	=> name        => q (object does not perform Testing::Role)
	=> diag        => <<'EXPECTED_DIAG'
+----+--------------------------------------+----+--------------------+
| Elt|Got                                   | Elt|Expected            |
+----+--------------------------------------+----+--------------------+
*   0|bless( {}, 'Testing::Non_Consumer' )  *   0|expect_does (       *
|    |                                      *   1|  'Testing::Role',  *
|    |                                      *   2|)                   *
+----+--------------------------------------+----+--------------------+
Checking role of $data with DOES()
   got : Testing::Non_Consumer=HASH(0x...)
expect : does role 'Testing::Role'
EXPECTED_DIAG
	;

check_test q (should fail with class name)
	=> assumption {
		it q (class name does not perform role)
			=> got    { Testing::Consumer:: }
			=> expect => expect_does (q (Testing::Role))
			;
	}
	=> ok          => 0
	=> actual_ok   => 0
	=> name        => q (class name does not perform role)
	=> diag        => <<'EXPECTED_DIAG'
+----+---------------------+----+--------------------+
| Elt|Got                  | Elt|Expected            |
+----+---------------------+----+--------------------+
*   0|'Testing::Consumer'  *   0|expect_does (       *
|    |                     *   1|  'Testing::Role',  *
|    |                     *   2|)                   *
+----+---------------------+----+--------------------+
Checking role of $data with DOES()
   got : 'Testing::Consumer'
expect : does role 'Testing::Role'
EXPECTED_DIAG
	;

check_test q (should fail with undef)
	=> assumption {
		it q (undef does not perform role)
			=> got    { undef }
			=> expect { expect_does (q (Testing::Role)) }
			;
	}
	=> ok          => 0
	=> actual_ok   => 0
	=> name        => q (undef does not perform role)
	=> diag        => <<'EXPECTED_DIAG'
+----+-------+----+--------------------+
| Elt|Got    | Elt|Expected            |
+----+-------+----+--------------------+
*   0|undef  *   0|expect_does (       *
|    |       *   1|  'Testing::Role',  *
|    |       *   2|)                   *
+----+-------+----+--------------------+
Checking role of $data with DOES()
   got : undef
expect : does role 'Testing::Role'
EXPECTED_DIAG
	;

had_no_warnings;
done_testing;
