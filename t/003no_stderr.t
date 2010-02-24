#! /usr/bin/perl

use strict;
use warnings;

use Test::More tests=>1;
use Test::Trap;
use Test::Differences;

use FindBin;
FindBin->again;
use lib "$FindBin::Bin/../lib";

use MyApp::Login;

my @r = trap { MyApp::Login::login(); };
eq_or_diff ( $trap->stderr, '', 'Expecting no STDOUT' );
#  like ( $trap->stderr, qr/^Bad parameters; exiting\b/, 'Expecting warnings.' );
