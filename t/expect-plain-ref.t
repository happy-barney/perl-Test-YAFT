#!/usr/bin/env perl

use v5.14;
use warnings;

use require::relative q (test-helper.pl);

package Testing::Blessed::Object {
	sub new {
		return bless {}, shift;
	}
}

check_test q (successful validation with plain reference)
	=> assumption {
		it q (should pass with plain reference)
			=> got    => {}
			=> expect => expect_plain_ref
			;
	}
	=> ok          => 1,
	=> actual_ok   => 1,
	=> name        => q (should pass with plain reference),
	;

check_test q (failed validation with blessed object)
	=> assumption {
		it q (should fail with blessed object)
			=> got    => Testing::Blessed::Object::->new
			=> expect => expect_plain_ref
			;
	}
	=> ok          => 0,
	=> actual_ok   => 0,
	=> name        => q (should fail with blessed object),
	=> diag        => <<'END_OF_DIAG'
+----+-----------------------------------------+----------------------------------------------+
| Elt|Got                                      |Expected                                      |
+----+-----------------------------------------+----------------------------------------------+
*   0|bless( {}, 'Testing::Blessed::Object' )  |bless( {}, 'Test::YAFT::Expect::Plain_Ref' )  *
+----+-----------------------------------------+----------------------------------------------+
Compared $data
   got : Testing::Blessed::Object=HASH(0x...)
expect : Plain (non-blessed) reference
END_OF_DIAG
	;

check_test q (failed validation with scalar value)
	=> assumption {
		it q (should fail with scalar)
			=> got    => q (foo)
			=> expect => expect_plain_ref
			;
	}
	=> ok          => 0,
	=> actual_ok   => 0,
	=> name        => q (should fail with scalar),
	=> diag        => <<'END_OF_DIAG'
+----+-------+----------------------------------------------+
| Elt|Got    |Expected                                      |
+----+-------+----------------------------------------------+
*   0|'foo'  |bless( {}, 'Test::YAFT::Expect::Plain_Ref' )  *
+----+-------+----------------------------------------------+
Compared $data
   got : 'foo'
expect : Plain (non-blessed) reference
END_OF_DIAG
	;

check_test q (failed complementary validation with plain reference)
	=> assumption {
		it q (should fail with plain reference)
			=> got    => {}
			=> expect => ! expect_plain_ref
			;
	}
	=> ok          => 0,
	=> actual_ok   => 0,
	=> name        => q (should fail with plain reference),
	=> diag        => <<'END_OF_DIAG'
+----+-----+----+--------------------------------------+
| Elt|Got  | Elt|Expected                              |
+----+-----+----+--------------------------------------+
*   0|{}   *   0|bless( {                              *
|    |     *   1|  _complement => 1                    *
|    |     *   2|}, 'Test::YAFT::Expect::Plain_Ref' )  *
+----+-----+----+--------------------------------------+
Compared $data
   got : HASH(0x...)
expect : Anything but plain (non-blessed) reference
END_OF_DIAG
	;

check_test q (successful complementary validation with blessed object)
	=> assumption {
		it q (should pass with blessed object)
			=> got    => Testing::Blessed::Object::->new
			=> expect => ! expect_plain_ref
			;
	}
	=> ok          => 1,
	=> actual_ok   => 1,
	=> name        => q (should pass with blessed object),
	;

check_test q (successful complementary validation with scalar value)
	=> assumption {
		it q (should pass with scalar)
			=> got    => q (foo)
			=> expect => ! expect_plain_ref
			;
	}
	=> ok          => 1,
	=> actual_ok   => 1,
	=> name        => q (should pass with scalar),
	;

had_no_warnings;
done_testing;
