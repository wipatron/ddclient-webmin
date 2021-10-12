#!/usr/bin/perl
#
# Author:	D. Bierer <doug@unlikelysource.com>
# Date:		22 Jan 2009
# Notes:	None
#

require './ddclient-lib.pl';

$output1 = &enable_disable_ddclient ( "false" );
$output2 = &stop_ddclient ();
$output3 = &kill_ddclient;
$output4 = &status_ddclient;
$output = $output1 . "%3Cbr%3E" . $output2 . "%3Cbr%3E" . $output3 . "%3Cbr%3E" . $output4;

&redirect("./index.cgi?response=$output");
