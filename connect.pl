#!/usr/bin/perl -w

use strict;
use warnings;

use JSON;
use Data::Dumper;
use Net::Curl::Easy qw(/^CURLOPT_.*/);

sub SendAeroGearNotification
{
    my ($url , $username , $password , $config) = @_;
    my $curl = Net::Curl::Easy->new;
    my $json = JSON->new();
    my $response_body;

    my $json_string = $json->encode($config);

    print "json string $json_string\n";

    $curl->setopt( CURLOPT_URL, $url);
    $curl->setopt( CURLOPT_SSL_VERIFYHOST , 0);
    $curl->setopt( CURLOPT_SSL_VERIFYPEER , 0);

    $curl->setopt( CURLOPT_USERPWD , "$username:$password");
    $curl->setopt( CURLOPT_HTTPHEADER, ['Content-Type: application/json' ,
                                        'Accept: application/json']);
    $curl->setopt( CURLOPT_POST , 1);
    $curl->setopt( CURLOPT_POSTFIELDS , $json_string);

    $curl->setopt( CURLOPT_WRITEDATA , \$response_body);

    $curl->perform;
    print "AeroGear Reponse=".Dumper($response_body);
}

my $notification_config = {
    variants => [ "<< YOUR AEROGEAR VARIANT ID1 >>" , "<< YOUR AEROGEAR VARIANT ID2 (IF ANY) >>" ] ,
    alias => [ "<< YOUR DEVICE ALIAS1 >>" , "<< YOUR DEVICE ALIAS2 >>" , "<< YOUR DEVICE ALIAS3 >>"] ,
    ttl => 600 ,
    message => {
        alert => "This is a test"
    }
};

SendAeroGearNotification("<< YOUR AEROGEAR URL >>" ,
                         "<< YOUR AEROGEAR APPLICATION ID >>" ,
                         "<<"YOUR AEROGEAR MASTER SECRET >> ,
                         $notification_config);

exit(0);
