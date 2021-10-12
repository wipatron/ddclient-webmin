#!/usr/bin/perl
#
# ddclient Webmin module, $Date: 2009-04-28
# Copyright (C) 2009 MagicWave Systems
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

require 'ddclient-lib.pl';

# Pull out help and version
$version = &ddclient_version;

&ui_print_header($version, $text{'index_title_main'},"",undef,1,1,undef, 
    &help_search_link("ddclient", "man", "doc", "google"), undef, undef, undef);
&ReadParse();

&error_setup("$text{'error_critical'}");

# print '<a href="ddclient-lib-test.cgi">goto test</a>';

if ( -r $config{'exec1'} ) {

	# Display MWS icon and ddclient version
	print "<table border=0 width=100%><tr><td align=left>";
	print "<a href='http://www.magicwave-sys.com/' style='text-decoration:none;' target='_blank'><img src='./images/icon.gif'></a></td>\n";
	print "</tr></table>\n";

	# Display operational icons
	&ddclient_display_icons();

	print "<hr/>";

	# Summarize the configured hosts and their status
	my ($service_result, $host_status_ref, $last_run) = ddclient_service_status_all(
		$config{'cache1'}, ddclient_conf_parse_multi());
	
	print $text{'display_host_monitored'} . ":";		
	print ui_columns_start([$text{'show_services_header_host'}, $text{'show_services_header_status'}, $text{'show_services_header_dns_ip'}]);
	foreach my $hostname (keys %{$host_status_ref}) {
		my $host_ref = $host_status_ref->{$hostname};
		my @td_attrs;
		if ($host_ref->{'status'} ne 'good') {
			for ($i = 0; $i < 3; $i++) {
				push @td_attrs, 'style="background-color: #ffbdbd"';
			}
		}
		print ui_columns_row([$hostname, $host_ref->{'status'}, $host_ref->{'dns_ip'}], [@td_attrs]);
	}	
	print ui_columns_end();
	
	print text('index_status_last_run', scalar localtime($last_run));   
	
} else {

	&error("$text{'error_base_pgm_missing'}"); 
	%log_info = ( "error" => "$text{'error_base_pgm_missing'}" );
	&webmin_log("error", "module", $config{'exec1'}, \%log_info);
}

&ui_print_footer("./index.cgi",$text{'return'});
