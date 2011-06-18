#!/usr/bin/perl

use strict; use warnings FATAL => 'all';
use Test::More 0.88;

BEGIN {
  if ($^O eq 'MSWin32') {
    Test::More::plan(skip_all => 'these tests are for Win32 systems');
  }
}

BEGIN { use_ok( 'Net::Appliance::Session::APIv2') }

my $s = new_ok( 'Net::Appliance::Session::APIv2' => [
    Transport => "Telnet",
    Host => '192.168.0.55',
    Platform => "ios",
]);

my @out = ();
ok( $s->connect( username => 'Cisco', password => ($ENV{IOS_PASS} || 'letmein')), 'connected' );

ok( $s->cmd('show clock'), 'ran show clock' );
cmp_ok( (scalar $s->last_response), '=', 1, 'one line of clock');

ok( $s->cmd('show version'), 'ran show ver, no paging' );
@out = $s->last_response;
cmp_ok( scalar @out, '>', 20, 'lots of ver lines');

ok( $s->begin_privileged, 'begin priv, no pass' );
ok( eval{$s->end_privileged;1}, 'end priv' );
ok( $s->begin_privileged(password => ($ENV{IOS_PASS} || 'letmein')),
    'begin priv, with pass' );

ok( $s->cmd('show ip int br'), 'ran show ip int br' );
@out = $s->last_response;
cmp_ok( scalar @out, '=', 6, 'six interface lines');

ok( $s->begin_configure, 'begin configure' );
ok( eval{$s->end_configure;1}, 'end configure' );

ok( eval{$s->close;1}, 'disconnected, backed out of privileged' );

done_testing;