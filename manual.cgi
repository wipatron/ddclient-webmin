#!/usr/bin/perl
#
# Author:	D. Bierer <doug@unlikelysource.com>
# Date:		28 Jan 2009
# Notes:	None
#

require './ddclient-lib.pl';

&ui_print_header($text{'manual_title_sub'},
                 $text{'index_title_main'},
                 undef,
                 "manual",
                 undef,
                 0,
                 1,
                 &help_search_link("ddclient", "man", "doc", "google"), 
                 undef, undef, undef);
&ReadParse();

# Start form and HTML
print &ui_form_start( "./manual.cgi", "post");

print "<a href='http://www.magicwave-sys.com/' style='text-decoration: none;'>\n";
print "<img src='./images/icon.gif'></a>\n";

# Initialize arrays used by lower levels
&ddclient_select_options();

# Get clean data from environment
my $ref = &ddclient_clean();
%current = %$ref;
 
# Check to see if there is a protocol and use option
if ( !$current{'protocol'} || !$current{'use'} ) {
	# Get info from config file
	my ( $failure, $message, $ref2 ) = &ddclient_conf_parse();
	my %tmp = %$ref2;
	if ( !$current{'protocol'} ) {
		$current{'protocol'} = $tmp{'protocol'};
	}
	if ( !$current{'use'} ) {
		$current{'use'} = $tmp{'use'};
	}
}

# Manual operations
&ddclient_manual ();

print '<table border=0>' . "\n";
print '<tr><td width=40><input type=submit name="action" value="' . $text{'button_save'} . '"></td><td>' . $text{'manual_save_button'} . '</td></tr>' . "\n"; 
print '<tr><td width=40><input type=submit name="action" value="' . $text{'button_previous'} . '"></td><td>' . $text{'manual_previous_button'} . '</td></tr>' . "\n"; 
print '</table>' . "\n";

print &ui_hidden("not_first", 1);
print &ui_form_end;

#DEBUG
#print "<br><b>DEBUG INFO</b><hr align=left>\n";
#print "<br>CURRENT<hr align=left>\n";
#foreach $key (keys %current ) {
#	print "<br>$key --> $current{$key}\n";
#} 
#print "<br>IN<hr align=left>\n";
#foreach $key (keys %in ) {
#	print "<br>$key --> $in{$key}\n";
#} 
#DEBUG


&ui_print_footer("./index.cgi",$text{'return'});
