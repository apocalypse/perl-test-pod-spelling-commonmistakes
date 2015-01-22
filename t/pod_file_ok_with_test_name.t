use strict;
use warnings;
use FindBin qw/$RealBin/;
use lib "$RealBin/../lib";
use Test::More;
use Test::Pod::Spelling::CommonMistakes;

pod_file_ok(glob("$RealBin/../t/lib/PodValid.pm"),'A custom test name');

done_testing();
