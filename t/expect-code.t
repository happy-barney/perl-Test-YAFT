#!/usr/bin/env perl

use v5.14;
use warnings;

use require::relative q (test-helper.pl);

assume_test_yaft_exports expect_code
	=> by_default => 1
	=> on_demand  => 1
	=> by_tag     => [qw [all default expectations]]
	;

check_test q (should pass when comparing value under test via '$_')
	=> assumption {
		it q (should pass with 1)
			=> got    => 1
			=> expect => expect_code { $_ == 1 }
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (should pass with 1)
	;

check_test q (should pass when comparing value under test via '$_[0]')
	=> assumption {
		it q (should pass with 1)
			=> got    => 1
			=> expect => expect_code { $_[0] == 1 }
			;
	}
	=> ok          => 1
	=> actual_ok   => 1
	=> name        => q (should pass with 1)
	;

check_test q (should fail when comparing value under test via '$_')
	=> assumption {
		it q (should fail with 2)
			=> got    => 2
			=> expect => expect_code { $_ == 1, q ($_ not equal) }
			;
	}
	=> ok          => 0
	=> actual_ok   => 0
	=> name        => q (should fail with 2)
	=> diag        => $] < 5.016 ? <<'EXPECTED_DIAG_5_016' : $] < 5.022 ? <<'EXPECTED_DIAG_5_022' :  <<'EXPECTED_DIAG',
+----+-----+----+------------------------------------------+
| Elt|Got  | Elt|Expected                                  |
+----+-----+----+------------------------------------------+
*   0|2    *   0|expect_code (                             *
|    |     *   1|  sub {                                   *
|    |     *   2|      use warnings;                       *
|    |     *   3|      use strict 'refs';                  *
|    |     *   4|      BEGIN {                             *
|    |     *   5|          $^H{'feature_unicode'} = q(1);  *
|    |     *   6|          $^H{'feature_say'} = q(1);      *
|    |     *   7|          $^H{'feature_state'} = q(1);    *
|    |     *   8|          $^H{'feature_switch'} = q(1);   *
|    |     *   9|      }                                   *
|    |     *  10|      $_ == 1, '$_ not equal';            *
|    |     *  11|  },                                      *
|    |     *  12|)                                         *
+----+-----+----+------------------------------------------+
Ran coderef at $data on

'2'
and it said
$_ not equal
EXPECTED_DIAG_5_016
+----+-----+----+--------------------------------+
| Elt|Got  | Elt|Expected                        |
+----+-----+----+--------------------------------+
*   0|2    *   0|expect_code (                   *
|    |     *   1|  sub {                         *
|    |     *   2|      use warnings;             *
|    |     *   3|      use strict;               *
|    |     *   4|      no feature;               *
|    |     *   5|      use feature ':5.12';      *
|    |     *   6|      $_ == 1, '$_ not equal';  *
|    |     *   7|  },                            *
|    |     *   8|)                               *
+----+-----+----+--------------------------------+
Ran coderef at $data on

'2'
and it said
$_ not equal
EXPECTED_DIAG_5_022
+----+-----+----+--------------------------------+
| Elt|Got  | Elt|Expected                        |
+----+-----+----+--------------------------------+
*   0|2    *   0|expect_code (                   *
|    |     *   1|  sub {                         *
|    |     *   2|      use warnings;             *
|    |     *   3|      use strict;               *
|    |     *   4|      no feature ':all';        *
|    |     *   5|      use feature ':5.12';      *
|    |     *   6|      $_ == 1, '$_ not equal';  *
|    |     *   7|  },                            *
|    |     *   8|)                               *
+----+-----+----+--------------------------------+
Ran coderef at $data on

'2'
and it said
$_ not equal
EXPECTED_DIAG
	;

check_test q (should fail when comparing value under test via '$_[0]')
	=> assumption {
		it q (should fail with 2)
			=> got    => 2
			=> expect => expect_code { $_[0] == 1, '$_[0] not equal' }
			;
	}
	=> ok          => 0
	=> actual_ok   => 0
	=> name        => q (should fail with 2)
	=> diag        => $] < 5.016 ? <<'EXPECTED_DIAG_5_016' : $] < 5.022 ? <<'EXPECTED_DIAG_5_022' :  <<'EXPECTED_DIAG',
+----+-----+----+------------------------------------------+
| Elt|Got  | Elt|Expected                                  |
+----+-----+----+------------------------------------------+
*   0|2    *   0|expect_code (                             *
|    |     *   1|  sub {                                   *
|    |     *   2|      use warnings;                       *
|    |     *   3|      use strict 'refs';                  *
|    |     *   4|      BEGIN {                             *
|    |     *   5|          $^H{'feature_unicode'} = q(1);  *
|    |     *   6|          $^H{'feature_say'} = q(1);      *
|    |     *   7|          $^H{'feature_state'} = q(1);    *
|    |     *   8|          $^H{'feature_switch'} = q(1);   *
|    |     *   9|      }                                   *
|    |     *  10|      $_[0] == 1, '$_[0] not equal';      *
|    |     *  11|  },                                      *
|    |     *  12|)                                         *
+----+-----+----+------------------------------------------+
Ran coderef at $data on

'2'
and it said
$_[0] not equal
EXPECTED_DIAG_5_016
+----+-----+----+--------------------------------------+
| Elt|Got  | Elt|Expected                              |
+----+-----+----+--------------------------------------+
*   0|2    *   0|expect_code (                         *
|    |     *   1|  sub {                               *
|    |     *   2|      use warnings;                   *
|    |     *   3|      use strict;                     *
|    |     *   4|      no feature;                     *
|    |     *   5|      use feature ':5.12';            *
|    |     *   6|      $_[0] == 1, '$_[0] not equal';  *
|    |     *   7|  },                                  *
|    |     *   8|)                                     *
+----+-----+----+--------------------------------------+
Ran coderef at $data on

'2'
and it said
$_[0] not equal
EXPECTED_DIAG_5_022
+----+-----+----+--------------------------------------+
| Elt|Got  | Elt|Expected                              |
+----+-----+----+--------------------------------------+
*   0|2    *   0|expect_code (                         *
|    |     *   1|  sub {                               *
|    |     *   2|      use warnings;                   *
|    |     *   3|      use strict;                     *
|    |     *   4|      no feature ':all';              *
|    |     *   5|      use feature ':5.12';            *
|    |     *   6|      $_[0] == 1, '$_[0] not equal';  *
|    |     *   7|  },                                  *
|    |     *   8|)                                     *
+----+-----+----+--------------------------------------+
Ran coderef at $data on

'2'
and it said
$_[0] not equal
EXPECTED_DIAG
	;

had_no_warnings;
done_testing;
