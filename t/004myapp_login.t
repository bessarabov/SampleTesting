#! /usr/bin/perl

use strict;
use warnings;

#use Test::More tests=>1;
use Test::More "no_plan";
use Test::Trap;
use Test::Differences;
use DBD::Mock;

use FindBin;
FindBin->again;
use lib "$FindBin::Bin/../lib";

use MyApp::Login;

my $dbh = DBI->connect( 'DBI:Mock:', '', '' ) || die "Cannot create handle: $DBI::errstr\n";

my $u = 'bill';
my $p = 'password';

my $result;

my @r = trap { $result = MyApp::Login::login($dbh, $u, $p); };
eq_or_diff ( $trap->stderr, '', 'Expecting no STDOUT' );
eq_or_diff ( $result, 'USERNAME NOT FOUND', 'user do not exist' );

 print "Used statement: ", $sth->{mock_statement}, "\n",
        "Bound parameters: ", join( ', ', @{ $params } ), "\n";
