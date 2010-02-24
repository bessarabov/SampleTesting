#! /usr/bin/perl

use strict;
use warnings;

use v5.10;

use FindBin;
FindBin->again;
use lib "$FindBin::Bin/../lib";

use MyApp::Login;

&echo_hello;

sub echo_hello {
    say "Hello, World!";
}
