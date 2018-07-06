#!/usr/bin/perl

# Copyright (C) 2018  Jesse McGraw (jlmcgraw@gmail.com)
#
#-------------------------------------------------------------------------------
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see [http://www.gnu.org/licenses/].
#-------------------------------------------------------------------------------

# TODO
#
# DONE

# Standard libraries
use strict;
use warnings;
use autodie;
use Carp;
use Config;
use Data::Dumper;
use File::Glob ':bsd_glob';
use DBI;
use File::Basename;
use File::Copy;
use File::Spec::Functions 'catfile';

# Allow use of locally installed libraries in conjunction with Carton
# without executing this script via "carton exec <script>"
use FindBin '$Bin';
use lib "$FindBin::Bin/local/lib/perl5";

# Non-standard libraries
use Modern::Perl '2015';
use Params::Validate qw(:all);
use Getopt::ArgParse;    #https://github.com/mytram/perl-argparse

# Call the main subroutine and exit with its return code
exit main(@ARGV);

sub main {

    # Process the command line
    my ( $ap, $args, @ARGV ) = process_command_line();

    # Examples of getting parameter values
    my $target_directory = $args->target;
    my $is_dry_run       = $args->dry_run;

    # Make sure the target directory exists
    unless ( -e $target_directory ) {
        say STDERR "Target directory does not exist";
        $ap->print_usage;
        return 1;
    }

    # Construct the path to the database
    my $recordings_database = catfile( $target_directory, 'Recordings.db' );

    # Make sure the database exists
    unless ( -r "$recordings_database" ) {
        say "Database file $recordings_database does not exist";
        die;
    }

    # connect to the database
    my $dbh = DBI->connect( "dbi:SQLite:dbname=$recordings_database",
        "", "", { RaiseError => 1 } )
      or croak $DBI::errstr;

    # Query recordings database
    my $sth = $dbh->prepare("select ZCUSTOMLABEL,ZPATH from ZRECORDING");

    $sth->execute();

    my $_allSqlQueryResults = $sth->fetchall_arrayref();
    my $_rows               = $sth->rows;

    say "Processing $_rows recordings";

    my $ZCUSTOMLABEL;
    my $ZPATH;

    foreach my $_row (@$_allSqlQueryResults) {

        ( $ZCUSTOMLABEL, $ZPATH ) = @$_row;

        # Parse the file info
        my ( $filename, $dir, $ext ) = fileparse( $ZPATH, qr/\.[^.]*/ );

        #         say "$ZCUSTOMLABEL, $ZPATH, $filename, $dir, $ext";

        # Construct the path to original file
        my $original_filename = catfile( $target_directory, "$filename$ext" );

        # Provide a description if one does not already exist
        unless ($ZCUSTOMLABEL) {
            $ZCUSTOMLABEL = "No description found";
        }

        # Construct the new file name
        my $new_filename =
          catfile( $target_directory, "$filename$ext - $ZCUSTOMLABEL" );

        # If the original file exists
        if ( -e "$original_filename" ) {

            # and the new file does not already exist
            unless ( -e "$new_filename" ) {

                # Copy the original file to the new one
                # unless this is a dry run
                if ($is_dry_run) {
                    say "Dry run: $original_filename -> \"$new_filename";
                }
                else {
                    say "Copying $original_filename -> \"$new_filename";
                    copy $original_filename, $new_filename;
                }
            }
        }
    }

    # Close the recordings database
    $sth->finish();
    $dbh->disconnect();

    return 0;
}

sub process_command_line {

    # Set up an argument parser
    my $ap = Getopt::ArgParse->new_parser(
        description =>
          'Rename iphone voice memo files in a directory based on the description in the database',
        epilog => 'Copyright (C) 2018  Jesse McGraw (jlmcgraw@gmail.com)',
    );

    # Various examples of adding parameters
    # edit/remove as needed

    # Add an option
    $ap->add_arg( '--target', '-t', default => '.' , help => "The target directory" );

    # Add an option
    $ap->add_arg( '--dry-run', '-n', type => 'Bool' , help => "Do a dry run, do not actually do anything" );

    # Parse the arguments
    my $args = $ap->parse_args() or $ap->print_usage;

    # Get @ARGV after options have been removed
    @ARGV = $ap->argv;

    # For saving unmodified ARGV if you need it for some reason
    # my @ARGV_unmodified;

    # Expand wildcards on command line since windows doesn't do it for us
    if ( $Config{archname} =~ m/win/ix ) {

        #Expand wildcards on command line
        say "Expanding wildcards for Windows";

        # @ARGV_unmodified = @ARGV;
        @ARGV = map { bsd_glob $_ } @ARGV;
    }

    return ( $ap, $args, @ARGV );
}