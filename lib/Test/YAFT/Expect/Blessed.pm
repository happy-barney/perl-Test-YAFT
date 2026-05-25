
use v5.14;
use warnings;

use Syntax::Construct qw (package-block package-version);

package Test::YAFT::Expect::Blessed {
	use parent qw (Test::Deep::Blessed);

	1;
}
