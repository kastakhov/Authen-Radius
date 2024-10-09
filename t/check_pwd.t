use strict;
use warnings;
use Test::More tests => 5;

BEGIN { use_ok('Authen::Radius') };

foreach (qw(127.0.0.1 ::1)) {
    my $auth = Authen::Radius->new(Host => $_, Secret => 'secret');
    ok($auth, 'object created');

    my $check = $auth->check_pwd('test', 'test');
    ok(! $check, 'no RADIUS available - check failed');
}