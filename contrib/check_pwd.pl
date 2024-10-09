#!/usr/bin/env perl
# Example script to check authentication on a RADIUS server
use strict;
use warnings;
use v5.10;
use Authen::Radius;
use Getopt::Long qw( GetOptions );

my ($verbose, $host, $secret, $user, $password, $dictionary, $radius);
GetOptions(
    'verbose' => sub {$verbose = 1},
    'host=s' => \$host,
    'secret=s' => \$secret,
    'user=s' => \$user,
    'password=s' => \$password,
    'dictionary=s' => \$dictionary
);
&help unless ($host && $secret && $user && $password);

STDOUT->autoflush(1);

say "Make sure this machine is in your Radius clients file!";

eval {
    $radius = Authen::Radius->new(
        Host   => $host,
        Secret => $secret,
        Debug  => $verbose,
    );
};

die $@ unless $radius;
$radius->load_dictionary($dictionary);

my $result = $radius->check_pwd( $user, $password );
if ($result) {
    say "Accept";
}
elsif ($radius->get_error() eq 'ENONE') {
    say "Reject";
}
else {
    say 'Error: ', $radius->strerror();
    exit 1;
}

my @attributes = $radius->get_attributes();
foreach my $attr (@attributes) {
    printf "%s %s = %s\n", $attr->{Vendor} // ' ', $attr->{Name}, $attr->{Value} // $attr->{RawValue};
}

sub help {
    say "Usage:";
    say "--host - provide hostname or IP of radius server";
    say "--secret - secret key for radius server";
    say "--user - username for test";
    say "--password - password for test user";
    say "--verbose - debug output";
    exit(1);
}
