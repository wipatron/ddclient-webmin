#!/usr/bin/perl
#
# Author:	D. Bierer <doug@unlikelysource.com>
# Date:		24 Jan 2009
# Notes:	None
#

require './ddclient-lib.pl';
&ui_print_header($text{'index_log'},$text{'index_title_main'},"",undef,1,undef);
&ReadParse();

print &ui_form_start( "./reset.cgi", "post");

$output = &reset_ddclient;
my $title = $text{'display_warning'} . ": " . $text{'display_reset_warning'};

print &ui_table_start($title, "width=100%", 2);
print '<tr><td width=40><input type=submit name="action" value="' . $text{'button_reset'} . '"></td>';
print '<td>' . $text{'display_reset_button_descr'} . '</td></tr>' . "\n"; 
print &ui_table_end();
print &ui_form_end;

print "<p>$output</p>\n";

&ui_print_footer("./index.cgi",$text{'return'});
