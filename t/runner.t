use strict;
use warnings;
use FindBin qw/$RealBin/;
use lib "$RealBin/../lib";
use Test::More;
use Test::Pod::Spelling::CommonMistakes;

my $command = "prove -v $RealBin/../t/pod_*.t";
my $output = `$command`;

like($output,qr/ok 1 - Spelling test for.+Pod\/Spelling\/CommonMistakes\.pm/,'pod_files_ok has runs against expected files');
like($output,qr/ok 1 - Spelling test for.+PodValid\.pm/,'pod_files_ok has runs against expected files');
like($output,qr/ok 1 - A custom test name/,'pod_file_ok has correct test name');

done_testing();
