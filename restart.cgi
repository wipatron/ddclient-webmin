#!/usr/bin/perl
#
# Author:	D. Bierer <doug@unlikelysource.com>
# Date:		22 Jan 2009
# Notes:	None
#

require './ddclient-lib.pl';

$output1 = &kill_ddclient;
$output2 = &restart_ddclient;
$output3 = &status_ddclient;
$output = $output1 . "%3Cbr%3E" . $output2 . "%3Cbr%3E" . $output3;

&redirect("./index.cgi?response=$output");

