use strict;
use warnings;
use Test::More tests => 5;

BEGIN { use_ok('Authen::Radius', qw(ACCOUNTING_RESPONSE)) };

foreach (qw(127.0.0.1 ::1)) {
    my $auth = Authen::Radius->new(Host => $_, Secret => 'secret', Debug => 0);
    ok($auth, 'object created');

    # without any attributes
    my $reply = $auth->send_packet(ACCOUNTING_RESPONSE);
    ok($reply);
    # diag $r->get_error;
    # diag $r->error_comment;
}