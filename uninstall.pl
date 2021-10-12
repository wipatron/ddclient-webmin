#!/usr/bin/perl
#
# Author:	D. Bierer <doug@unlikelysource.com>
# Date:		23 Jan 2009
# Notes:	None
#

require 'ddclient-lib.pl';

sub module_uninstall
{
	# Copies /etc/webmin/ddclient/ddclient.conf.original to /etc/ddclient.conf
	$dest 	= $config{'conf1'};
	$src1	= $module_config_directory . "/" . &ddclient_just_filename ( $src ) . ".original";
	`cp $src1 $dest`;

	# Copies /etc/webmin/ddclient_daemon.original to /etc/default/ddclient
	$dest 	= $config{'conf2'};
	$src2	= $module_config_directory . "/" . &ddclient_just_filename ( $src ) . "_daemon.original";
	`cp $src2 $dest`;

	# Erase /etc/webmin/ddclient/config
	$src3 = $module_config_directory . "/config";
	unlink ( $src3 );

}
