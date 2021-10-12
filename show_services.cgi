#!/usr/bin/perl
#
# Author:	B. Schlarmann <bschlarmann@odesk.com>
# Date:		11 March 2009
# Notes:	None
#

require './ddclient-lib.pl';

sub show_services_create_link {
	my ($type, $number, $host, $image, $as_title) = @_;
	
	return '<a href="do_services.cgi?action=' . $type . '&service_definition=' . $number . 
		($host ? "&hostname=$host" : '') . '">' . 
		($image ? '<img src="' . $image . '"' . 
			($as_title ? '" title="' . $text{'show_services_' . $type} : "").  		
			'"/>' : 
		"") .
		($as_title ? "" : $text{'show_services_' . $type}) . "</a>";
}

&ui_print_header($text{'show_services_title'},
                 $text{'index_title_main'},
                 undef,
                 "show_services",
                 undef,
                 0,
                 1,
                 &help_search_link("ddclient", "man", "doc", "google"), 
                 undef, undef, undef);

&ReadParse();

my $config = ddclient_conf_parse_multi();

print <<ADD_HOSTNAME_BOX;
<style type="text/css">
img {
	vertical-align: middle;	
}
</style>
<script type="text/javascript">
function showHostnameBox(service_name, service_no) {
	document.getElementById("add_hostname_service").value = service_no;
	document.getElementById("add_hostname_box_title").innerHTML = service_name;
	document.getElementById("add_hostname_box").style.display = "inline";		
}

function hideHostnameBox() {
	document.getElementById("add_hostname_box").style.display = "none";
}
</script>

<div style="display: none; position: absolute; height: 80%; width: 90%; margin: 0px 0px; margin: auto auto auto auto" id="add_hostname_box">
<div style="background-color: lightgrey; height: 120px; width: 350px; margin: auto auto; margin-top: 150px; border: thick solid black;">
	<br/>
	<form id="add_hostname_form" method="POST" action="do_services.cgi">
	<input type="hidden" name="action" value="add_hostname"/>
	<input type="hidden" name="service_definition" id="add_hostname_service"/>
	
	<div id="add_hostname_box_title"></div>
	Hostname: <input type="text" name="hostname"/><br/><br/>
ADD_HOSTNAME_BOX
print '<input type="submit" name="submit" value="' . $text{'add'} . '"/>';
print '<input type="button" name="cancel" value="' . $text{'cancel'} . '" onClick="javascript:hideHostnameBox();"/>';
print '</form></div></div>';


print &ui_form_start( "./config.cgi", "post");

print "<a href='http://www.magicwave-sys.com/' style='text-decoration: none;'>\n";
print "<img src='./images/icon.gif'></a>\n";

&ddclient_select_options();

icons_table( ['add_service.cgi', 'do_services.cgi?action=edit_ip_acq', 'show_services.cgi'], 
			 [$text{'show_services_add_service'}, $text{'show_services_edit_ip_acq'}, $text{'show_services_refresh'} ], 
			 ["images/hostnames_add.png", "images/ip_acq.png", "images/refresh_small.png"] );


print "<hr/>";

my ($ip_stat, $ip_used) = ddclient_query_ip($config);

print $text{'show_services_ip'} . ": <tt>";
if ($ip_stat eq 'success') {
	 print $ip_used;
}
else {
	print $text{'add_service_check_ip_acq_failure'} . ": " . $ip_used;
}

print "</tt><br/><br/>";

if ($in{'refresh_hostname_msg'}) {
	my $msg = $in{'refresh_hostname_msg'};
	print '<div style="border: 1px dashed black">' . $text{'show_services_response'} . ": " . $msg . "</div>";
}

print "<br/>";

my @services = @{$config->{'services'}};
my ($serv_stats, $host_stats) = ddclient_service_status_all($config{'cache1'}, $config);

if (!@services) {
	print '<div style="width: 100%"><div style="width: 60%; margin-left: auto; margin-right: auto;"><img src="images/warning.png"/>';
	print $text{'show_services_nohostnames'};
	print '</div></div>';
}

my $number = 0;
foreach my $service (@services) {
	my $service_name = ddclient_service_description($service);
	print ui_table_start(
		$text{'show_services_service'} . ": " . $service_name, 'width="100%"', 1);
			
	print ui_table_row("", 
		'<a href="#" onClick="javascript:showHostnameBox(\'' . 
				$text{'show_services_add_hostname'} . ': ' .	$service_name . "', '" . $number . '\');">' .
			'<img src="images/enable_small.png"/>'.
			$text{'show_services_add_hostname'} . '</a> | ' . 
			show_services_create_link('edit_service', $number, undef, 'images/edit_small.png') . ' | ' .
			show_services_create_link('remove_service', $number, undef, 'images/disable_small.png') . ' | ' . 
			'<a href="edit_service.cgi?service_definition=' . $number . '"><img src="images/edit_small.png"/>' .							
			 $text{'show_services_edit_manual'} . '</a>',
			undef, []);
	
	print ui_columns_start([
		$text{'show_services_header_host'},
		$text{'show_services_header_status'},
		$text{'show_services_header_atime'},
		$text{'show_services_header_mtime'},		
		$text{'show_services_header_cache_ip'},
		$text{'show_services_header_dns_ip'},
		$text{'show_services_header_action'}], undef, 1, "");
		
	foreach my $host (@{$service->{'hostnames'}}) {
		warn($host);
		
		# only allow removal when hosts > 1
		my $remove_link;
		if (@{$service->{'hostnames'}} > 1) {
			$remove_link = show_services_create_link('remove_host', $number, $host, "images/disable_small.png", 1);
		}
		else {
			$remove_link = '<span style="text-decoration: line-through" title="' . $text{'show_services_remove_host_one'} . 
				'"><img src="images/disable_small.png"/>' . '</span>';
		}
		my $refresh_link = show_services_create_link('refresh_hostname', $number, $host, "images/refresh_smallest.png", 1);
		
		my $host_status = $host_stats->{$host};
		print ui_columns_row([ $host, $host_status->{'status'}, $host_status->{'atime'}, $host_status->{'mtime'}, 
			$host_status->{'cache_ip'}, $host_status->{'dns_ip'}, $remove_link . ' | ' . $refresh_link ], 
			["width=20%", "width=10%", "width=20%", "width=20%", "width=10%", "width=10%", "width=10%"]);
	}
	
	print ui_columns_end();
	print ui_table_end();
	print "<hr/>";
	
	$number++;
}

&ui_print_footer("./index.cgi",$text{'return'});