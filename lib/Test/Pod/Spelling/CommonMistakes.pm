# Declare our package
package Test::Pod::Spelling::CommonMistakes;
use strict; use warnings;

# Initialize our version
use vars qw( $VERSION );
$VERSION = '0.01';

# Import the modules we need
use Pod::Spell::CommonMistakes qw( check_pod_all );
use Test::Pod ();

# setup our tests and etc
use Test::Builder;
my $Test = Test::Builder->new;

# auto-export our 2 subs
use base qw( Exporter );
our @EXPORT = qw( pod_file_ok all_pod_files_ok ); ## no critic ( ProhibitAutomaticExportation )

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

sub all_pod_files_ok {
	my @files = @_ ? @_ : Test::Pod::all_pod_files();

	$Test->plan( tests => scalar @files );

	my $ok = 1;
	foreach my $file ( @files ) {
		pod_file_ok( $file ) or undef $ok;
	}

	return $ok;
}

1;
__END__

=for stopwords AnnoCPAN CPAN CPANTS Kwalitee RT TESTNAME spellchecker

=head1 NAME

Test::Pod::Spelling::CommonMistakes - Checks POD for common spelling mistakes

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

This module checks your POD for common spelling errors. This differs than L<Test::Spelling> because it doesn't use your system spellchecker
and instead uses L<Pod::Spell::CommonMistakes> for the heavy lifting. Using it is the same as any standard Test::* module, as seen here.

=head1 Methods

=head2 all_pod_files_ok( [ @files ] )

This function is what you will usually run. It automatically finds any POD in your distribution and runs checks on them.

Accepts an optional argument: an array of files to check. By default it checks all POD files it can find in the distribution. Every file it finds
is passed to the C<pod_file_ok> function.

=head2 pod_file_ok( $file, [ $name ] )

C<pod_file_ok()> will okay the test if there is spelling errors present in the POD. Furthermore, if the POD was
malformed as reported by L<Pod::Simple>, the test will fail and not attempt to check spelling.

When it fails, C<pod_file_ok()> will show any misspelled words and their suggested spelling as diagnostics.

The optional second argument $name is the name of the test.  If it is omitted, C<pod_file_ok()> chooses a default
test name "Spelling test for $file".

=head1 EXPORT

Automatically exports the two subs.

=head1 SEE ALSO

L<Pod::Spell::CommonMistakes>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

	perldoc Test::Pod::Spelling::CommonMistakes

=head2 Websites

=over 4

=item * Search CPAN

L<http://search.cpan.org/dist/Test-Pod-Spelling-CommonMistakes>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Test-Pod-Spelling-CommonMistakes>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Test-Pod-Spelling-CommonMistakes>

=item * CPAN Forum

L<http://cpanforum.com/dist/Test-Pod-Spelling-CommonMistakes>

=item * RT: CPAN's Request Tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Test-Pod-Spelling-CommonMistakes>

=item * CPANTS Kwalitee

L<http://cpants.perl.org/dist/overview/Test-Pod-Spelling-CommonMistakes>

=item * CPAN Testers Results

L<http://cpantesters.org/distro/T/Test-Pod-Spelling-CommonMistakes.html>

=item * CPAN Testers Matrix

L<http://matrix.cpantesters.org/?dist=Test-Pod-Spelling-CommonMistakes>

=item * Git Source Code Repository

L<http://github.com/apocalypse/perl-test-pod-spelling-commonmistakes>

=back

=head2 Bugs

Please report any bugs or feature requests to C<bug-test-pod-spelling-commonmistakes at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Test-Pod-Spelling-CommonMistakes>.  I will be
notified, and then you'll automatically be notified of progress on your bug as I make changes.

=head1 AUTHOR

Apocalypse E<lt>apocal@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2010 by Apocalypse

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

The full text of the license can be found in the LICENSE file included with this module.

=cut
