use strict;
use warnings;
use Test::More tests => 7;

BEGIN { use_ok('Authen::Radius') };

foreach (qw(127.0.0.1 ::1)) {
    my $auth = Authen::Radius->new(Host => $_, Secret => 'secret', Debug => 0);
    ok($auth, 'object created');

    # Name as ID but missing Type
    $auth->add_attributes(
        { Name => 1, Value => 'test' },
        { Name => 2, Value => 'test' },
    );

    is( scalar($auth->get_attributes), 0, 'no attributes encoded');
    ok( $auth->send_packet(ACCESS_REQUEST), 'sent without attributes');
    # diag $r->get_error;
    # diag $r->error_comment;
}
