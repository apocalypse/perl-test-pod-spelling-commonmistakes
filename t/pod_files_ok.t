use strict;
use warnings;
use FindBin qw/$RealBin/;
use lib "$RealBin/../lib";
use Test::More;
use Test::Pod::Spelling::CommonMistakes;

all_pod_files_ok();

done_testing();
