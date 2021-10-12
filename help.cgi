#!/usr/bin/perl
#
# Author:	D. Bierer <doug@unlikelysource.com>
# Date:		22 Jan 2009
# Notes:	None
#

require './ddclient-lib.pl';

&ui_print_header($text{'index_title_sub'},$text{'index_title_main'},"",undef,1,undef);

&error_setup("$text{'error_critical'}");
if ( -r $config{'exec1'} ) {

	# Pull out help and version
	$version = &ddclient_version;
	# Display MWS icon and ddclient version
	print "<table border=0 width=100%><tr><td align=left><a href='http://www.magicwave-sys.com' target='_blank' style='text-decoration:none;'>";
	print "<img src='./images/icon.gif'></a></td>";
	print "<td align=right>$version</td></tr></table>\n";

	@headings = ( $text{'heading_help'} );	
	print &ui_columns_start(\@headings);
	print "<tr><td>";
	print "<a href='http://ddclient.wiki.sourceforge.net/Usage' target='_blank' style='text-decoration:none;'>";
	print "ddclient Wiki</a></td></tr>\n";
	print "<tr><td>";
	print &help_ddclient ();
	print "</td></tr>\n";
	print &ui_columns_end;
	
} else {

	&error("$text{'error_base_pgm_missing'}"); 
	%log_info = ( "error" => "$text{'error_base_pgm_missing'}" );
	&webmin_log("error", "module", $config{'exec1'}, \%log_info);
}

&ui_print_footer("./index.cgi",$text{'return'});
