#!/usr/bin/perl
#
# Author:	D. Bierer <doug@unlikelysource.com>
# Date:		25 Jan 2009
# Notes:	None
#

require 'ddclient-lib.pl';

sub module_install
{

	&error_setup("$text{'error_critical'}");

	# Copies /etc/ddclient.conf to /etc/webmin/ddclient/ddclient.conf.original
	$src 	= $config{'conf1'};
	$dest	= $module_config_directory . "/" . &ddclient_just_filename ( $src ) . ".original";
	`cp $src $dest`;

	# Copies /etc/default/ddclient to /etc/webmin/ddclient_daemon.original
	$src 	= $config{'conf2'};
	$dest	= $module_config_directory . "/" . &ddclient_just_filename ( $src ) . "_daemon.original";
	`cp $src $dest`;
	
	my $umod = umask();
	umask("0077");
	`touch $module_config_directory/empty_config`;
	umask($umod);
	
	

# This prevents users from installing the module when not all binaries are available, this is
# unwanted behaviour however.
#	if ( ! -r $config{'exec1'} ) {
#
#		# Get rid of /etc/webmin/ddclient/config
#		$dest	= $module_config_directory . "/config";
#		unlink ( $dest );
#		
#		# Inform user
#		&error("$text{'error_base_pgm_missing'}"); 
#		%log_info = ( "error" => "$text{'error_base_pgm_missing'}" );
#		&webmin_log("error", "module", $config{'exec1'}, \%log_info);
#
#	}
#
#	if ( ! -r $config{'exec3'} ) {
#
#		# Inform user
#		&error("$text{'error_sendmail_missing'}"); 
#		%log_info = ( "error" => "$text{'error_sendmail_missing'}" );
#		&webmin_log("error", "module", $config{'exec3'}, \%log_info);
#
#	}

}
