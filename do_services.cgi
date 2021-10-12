#!/usr/bin/perl
#
# Author:	B. Schlarmann <bschlarmann@odesk.com>
# Date:		21 March 2009
# Notes:	None
#

require "./ddclient-lib.pl";

ReadParse();
ddclient_select_options();

my $action = $in{'action'};


if ($action eq 'remove_host') {
	my $host = $in{'hostname'};
	my $service_definition = $in{'service_definition'};
	
	my $config = ddclient_conf_parse_multi();
	my $service = $config->{'services'}->[$service_definition];
		
	$service->{'hostnames'} = [grep { $_ ne $host } @{$service->{'hostnames'}}];
	ddclient_config_save_multi($config);
	
	webmin_log("delete", "hostname", $host);
}
elsif ($action eq 'add_hostname') {
	my $hostname = $in{'hostname'};
	my $service_definition = $in{'service_definition'};
	
	my $config = ddclient_conf_parse_multi();
	my $service = $config->{'services'}->[$service_definition];
	
	push @{$service->{'hostnames'}}, $hostname;
	
	ddclient_config_save_multi($config);
	
	webmin_log("create", "hostname", $hostname);
}
elsif ($action eq 'edit_service') {
	my $service_definition = $in{'service_definition'};
	
	my $config = ddclient_conf_parse_multi();
	$service = $config->{'services'}->[$service_definition];	
	delete $service->{'hostnames'};
	
	$service->{'is_edit'} = 1;
	$service->{'service_definition'} = $service_definition;
		
	redirect("add_service.cgi?type=service&current_config=" . ddclient_serialize_hash($service));
	return;
}
elsif ($action eq 'edit_ip_acq') {
	my $config = ddclient_conf_parse_multi();
	
	delete $config->{'services'};	
		
	redirect("add_service.cgi?type=ip_acq&current_config=" . ddclient_serialize_hash($config));
	return;	
}
elsif ($action eq 'remove_service') {
	my $config = ddclient_conf_parse_multi();
	my $service_definition = $in{'service_definition'};
	
	my $removed = splice(@{$config->{'services'}}, $service_definition, 1);
	
	ddclient_config_save_multi($config);
	
	webmin_log("delete", "service", ddclient_service_description($removed));
}
elsif ($action eq 'refresh_hostname') {
	my $hostname = $in{'hostname'};
	
	my $output = ddclient_hostname_force_update_convert(undef, $hostname);
		
	redirect("show_services.cgi?refresh_hostname_msg=" . urlize($output));
	return;
}

redirect("show_services.cgi");