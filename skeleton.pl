#!/usr/bin/env perl


use warnings;
use strict;
use Config::Simple;
use Data::Dumper;

#Import DynECT handler
use FindBin;
use lib "$FindBin::Bin/DynectDNS";  # use the parent directory
use DynECTDNS;

#Create config reader
my $cfg = new Config::Simple();

# read configuration file (can fail)
$cfg->read('config.cfg') or die $cfg->error();

#dump config variables into hash for later use
my %configopt = $cfg->vars();
my $apicn = $configopt{'cn'} or do {
	print "Customer Name required in config.cfg for API login\n";
	exit;
};

my $apiun = $configopt{'un'} or do {
	print "User Name required in config.cfg for API login\n";
	exit;
};

my $apipw = $configopt{'pw'} or do {
	print "User password required in config.cfg for API login\n";
	exit;
};


my $dynect = DynECTDNS->new();
$dynect->login( $apicn, $apiun, $apipw);

my $opt_zone = 'stonedynamic.com';
#Call REST/AllRecord on the zone
my $res = $dynect->request( "/REST/AllRecord/$opt_zone/", 'GET') or die $dynect->message;
print Dumper $dynect->result;
print $dynect->message;

