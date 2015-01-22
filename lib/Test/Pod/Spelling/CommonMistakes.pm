package Test::Pod::Spelling::CommonMistakes;

# ABSTRACT: Checks POD for common spelling mistakes

use strict;
use warnings;
# Import the modules we need
use Pod::Spell::CommonMistakes 0.01 qw( check_pod_all );
use Test::Pod 1.40 ();

# setup our tests and etc
use Test::Builder 0.94;
my $Test = Test::Builder->new;

# auto-export our 2 subs
use parent qw( Exporter );
our @EXPORT = qw( pod_file_ok all_pod_files_ok ); ## no critic ( ProhibitAutomaticExportation )

=method all_pod_files_ok( [ @files ] )

This function is what you will usually run. It automatically finds any POD in your distribution and runs checks on them.

Accepts an optional argument: an array of files to check. By default it checks all POD files it can find in the distribution. Every file it finds
is passed to the C<pod_file_ok()> function.

=cut

sub all_pod_files_ok {
	my @files = @_ ? @_ : Test::Pod::all_pod_files();

	$Test->plan( tests => scalar @files );

	my $ok = 1;
	foreach my $file ( @files ) {
		pod_file_ok( $file ) or undef $ok;
	}

	return $ok;
}

=method pod_file_ok( $file, [ $name ] )

C<pod_file_ok()> will okay the test if there is spelling errors present in the POD. Furthermore, if the POD was
malformed as reported by L<Pod::Simple>, the test will fail and not attempt to check spelling.

When it fails, C<pod_file_ok()> will show any misspelled words and their suggested spelling as diagnostics.

The optional second argument $name is the name of the test.  If it is omitted, C<pod_file_ok()> chooses a default
test name "Spelling test for $file".

=cut

sub pod_file_ok {
	my $file = shift;
	my $name = @_ ? shift : "Spelling test for $file";

	if ( ! -f $file ) {
		$Test->ok( 0, $name );
		$Test->diag( "Error: '$file' does not exist" );
		return;
	}

	# Parse the POD!
	my $res;
	eval {
		$res = check_pod_all( $file );
	};
	if ( $@ ) {
		$Test->ok( 0, $name );
		$Test->diag( "Error: Unable to parse '$file' - $@" );
		return;
	}

	# Did we get any errors?
	if ( keys %$res == 0 ) {
		$Test->ok( 1, $name );
		return 1;
	} else {
		$Test->ok( 0, $name );
		foreach my $e ( keys %$res ) {
			## no critic ( ProhibitAccessOfPrivateData )
			$Test->diag( "'$e' should be spelled " . $res->{ $e } );
		}
		return;
	}
}

1;

=pod

=for stopwords TESTNAME spellchecker

=head1 SYNOPSIS

	#!/usr/bin/perl
	use strict; use warnings;

	use Test::More;

	eval "use Test::Pod::Spelling::CommonMistakes";
	if ( $@ ) {
		plan skip_all => 'Test::Pod::Spelling::CommonMistakes required for testing POD';
	} else {
		all_pod_files_ok();
	}

=head1 DESCRIPTION

This module checks your POD for common spelling errors. This differs from L<Test::Spelling> because it doesn't use your system spellchecker
and instead uses L<Pod::Spell::CommonMistakes> for the heavy lifting. Using it is the same as any standard Test::* module, as seen here.

=head1 EXPORT

Automatically exports the two subs.

=head1 SEE ALSO
Pod::Spell::CommonMistakes

=cut
