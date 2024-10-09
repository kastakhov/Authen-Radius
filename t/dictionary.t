use strict;
use warnings;
use Test::More tests => 16;
use File::Spec ();
use Test::NoWarnings;

BEGIN { use_ok('Authen::Radius') };

foreach (qw(127.0.0.1 ::1)) {
    my $auth = Authen::Radius->new(Host => $_, Secret => 'secret', Debug => 0);
    ok($auth, 'object created');

    my $freeradius_path = $ENV{TEST_FREERADIUS_PATH} || '/usr/share/freeradius';

    SKIP: {
        skip 'no FreeRADIUS dictionary found', 6 if (! -d $freeradius_path);

        my $file = File::Spec->catdir($freeradius_path, 'dictionary.rfc2865');

        ok($auth->load_dictionary($file), 'dictionary loaded');
        # option 'encrypt=1' is parsed as vendor name, but as no such vendor was defined, we get correct result
        my $vendor = Authen::Radius::vendorID({ Name => 'User-Password', Value => 'test' });
        is($vendor, Authen::Radius->NO_VENDOR, 'no vendor attr');

        # reload dictionaries
        Authen::Radius->clear_dictionary();

        # parse using proper format
        ok($auth->load_dictionary($file, format => 'freeradius'), 'dictionary loaded');
        $vendor = Authen::Radius::vendorID({ Name => 'User-Password', Value => 'test' });
        is($vendor, Authen::Radius->NO_VENDOR, 'no vendor attr');

        Authen::Radius->clear_dictionary();

        my $cisco_file = File::Spec->catfile($freeradius_path, 'dictionary.cisco');
        ok($auth->load_dictionary($cisco_file, format => 'freeradius'), 'dictionary loaded');
        $vendor = Authen::Radius::vendorID({ Name => 'Cisco-IP-Direct', Value => 10 });
        is($vendor, 9, 'Cisco vendor');
    };
}