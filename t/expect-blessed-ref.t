#!/usr/bin/env perl

use v5.14;
use warnings;

use require::relative q (test-helper.pl);

assume_test_yaft_exports expect_blessed_ref
	=> by_default => 1
	=> on_demand  => 1
	=> by_tag     => [qw [all default expectations]]
	;

assume_yaft_dump q (Dumper should serialize 'expect_blessed_ref' call)
	=> got { expect_blessed_ref }
	=> expect => <<'END_OF_EXPECTED'
expect_blessed_ref ()
END_OF_EXPECTED
	;

package Testing::Blessed::Object {
	sub new {
		return bless {}, shift;
	}
}

check_test q (successful validation with blessed object)
	=> assumption {
		it q (should pass with blessed object)
			=> got    => Testing::Blessed::Object::->new
			=> expect => expect_blessed_ref
			;
	}
	=> ok          => 1,
	=> actual_ok   => 1,
	=> name        => q (should pass with blessed object),
	;

check_test q (failed validation with plain reference)
	=> assumption {
		it q (should fail with plain reference)
			=> got    => {}
			=> expect => expect_blessed_ref
			;
	}
	=> ok          => 0,
	=> actual_ok   => 0,
	=> name        => q (should fail with plain reference),
	=> diag        => <<'END_OF_DIAG'
+----+-----+-----------------------+
| Elt|Got  |Expected               |
+----+-----+-----------------------+
*   0|{}   |expect_blessed_ref ()  *
+----+-----+-----------------------+
Compared $data
   got : HASH(0x...)
expect : Blessed reference
END_OF_DIAG
	;

check_test q (failed validation with non-reference)
	=> assumption {
		it q (should fail with non-reference)
			=> got    => q (foo)
			=> expect => expect_blessed_ref
			;
	}
	=> ok          => 0,
	=> actual_ok   => 0,
	=> name        => q (should fail with non-reference),
	=> diag        => <<'END_OF_DIAG'
+----+-------+-----------------------+
| Elt|Got    |Expected               |
+----+-------+-----------------------+
*   0|'foo'  |expect_blessed_ref ()  *
+----+-------+-----------------------+
Compared $data
   got : 'foo'
expect : Blessed reference
END_OF_DIAG
	;

check_test q (failed complementary validation with blessed object)
	=> assumption {
		it q (should fail with blessed object)
			=> got    => Testing::Blessed::Object::->new
			=> expect => ! expect_blessed_ref
			;
	}
	=> ok          => 0,
	=> actual_ok   => 0,
	=> name        => q (should fail with blessed object),
	=> diag        => <<'END_OF_DIAG'
+----+-----------------------------------------+----+----------------------------------------+
| Elt|Got                                      | Elt|Expected                                |
+----+-----------------------------------------+----+----------------------------------------+
*   0|bless( {}, 'Testing::Blessed::Object' )  *   0|bless( {                                *
|    |                                         *   1|  _complement => 1                      *
|    |                                         *   2|}, 'Test::YAFT::Expect::Blessed_Ref' )  *
+----+-----------------------------------------+----+----------------------------------------+
Compared $data
   got : Testing::Blessed::Object=HASH(0x...)
expect : Anything but blessed reference
END_OF_DIAG
	;

check_test q (successful complementary validation with plain hash reference)
	=> assumption {
		it q (should pass with plain reference)
			=> got    => {}
			=> expect => ! expect_blessed_ref
			;
	}
	=> ok          => 1,
	=> actual_ok   => 1,
	=> name        => q (should pass with plain reference),
	;

check_test q (successful complementary validation with scalar value)
	=> assumption {
		it q (should pass with scalar)
			=> got    => q (foo)
			=> expect => ! expect_blessed_ref
			;
	}
	=> ok          => 1,
	=> actual_ok   => 1,
	=> name        => q (should pass with scalar),
	;

had_no_warnings;
done_testing;
