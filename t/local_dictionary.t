use strict;
use warnings;
use Test::More tests => 14;
use File::Spec ();
use Test::NoWarnings;

BEGIN { use_ok('Authen::Radius') };

foreach (qw(127.0.0.1 ::1)) {
    my $auth = Authen::Radius->new(Host => $_, Secret => 'secret', Debug => 0);
    ok($auth, 'object created');

    my $raddb_path = 'raddb';

    SKIP: {
        skip 'no local dictionary found', 5 if (! -d $raddb_path);

        ok($auth->load_dictionary($raddb_path . '/dictionary'), 'local dictionary loaded');
        $auth->add_attributes({ Name => 'Cisco-IP-Direct', Value => 10 });
        my @attr = $auth->get_attributes();
        is(@attr, 1, '1 attribute added');
        is($attr[0]->{Name}, 'Cisco-IP-Direct', 'name check');

        $auth->clear_attributes;

        $auth->add_attributes({ Name => 'WiMAX-MSK', Value => 0x10 });
        @attr = $auth->get_attributes();
        is(@attr, 1, '1 attribute added');
        is($attr[0]->{Name}, 'WiMAX-MSK', 'name check');
        $auth->clear_dictionary();
    };
}
