#!/usr/bin/perl
#
# Author:	D. Bierer <doug@unlikelysource.com>
# Date:		22 Jan 2009
# Notes:	None
#

require './ddclient-lib.pl';

$output1 = &force_reload_ddclient;
$output2 = &status_ddclient;
$output = $output1 . "%3Cbr%3E" . $output2;

&redirect("./index.cgi?response=$output");

