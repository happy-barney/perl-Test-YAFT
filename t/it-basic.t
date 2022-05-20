
use require::relative "test-helper.pl";

it "should got what is expected"
	=> got    => 10
	=> expect => 10
	;

had_no_warnings;

done_testing;
