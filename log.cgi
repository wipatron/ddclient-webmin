#!/usr/bin/perl
#
# Author:	D. Bierer <doug@unlikelysource.com>
# Date:		31 Jan 2009
# Notes:	None
#

require './ddclient-lib.pl';

&ui_print_header($text{'index_log'},
                 $text{'index_title_main'},
                 undef,
                 undef,
                 undef,
                 0,
                 1,
                 &help_search_link("ddclient", "man", "doc", "google"), 
                 undef, undef, undef);
&ReadParse();

# Pull out help and version
$version = &ddclient_version;
# Display MWS icon and ddclient version
print "<table border=0 width=100%><tr><td align=left><img src='./images/icon.gif'></td>";
print "<td align=right>$version</td></tr></table>\n";

&error_setup("$text{'error_critical'}");
if ( -r $config{'exec1'} ) {

	&log_ddclient ();
	
} else {

	&error("$text{'error_base_pgm_missing'}"); 
	%log_info = ( "error" => "$text{'error_base_pgm_missing'}" );
	&webmin_log("error", "module", $config{'exec1'}, \%log_info);

}

&ui_print_footer("./index.cgi",$text{'return'});
