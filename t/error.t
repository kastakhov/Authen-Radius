use strict;
use warnings;
use Test::More tests => 16;
use Test::NoWarnings;

BEGIN { use_ok('Authen::Radius') };


foreach (qw(127.0.0.1 ::1)) {
    my $auth = Authen::Radius->new(Host => $_, Secret => 'secret', Debug => 0);
    $auth->set_error('ETIMEOUT', 'test timeout');
    is($auth->get_error(), 'ETIMEOUT', 'error code');
    is(Authen::Radius->get_error(), 'ETIMEOUT', 'global error code');
    is($auth->strerror(), 'timed out waiting for packet', 'error message');
    is($auth->error_comment(), 'test timeout', 'error comment');

    # called by check_pwd()
    ok( $auth->clear_attributes, 'clear attributes');

    is($auth->get_error(), 'ENONE', 'error was reset');
    is(Authen::Radius->get_error(), 'ENONE', 'global error also reset');
}