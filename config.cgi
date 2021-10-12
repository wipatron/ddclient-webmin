#!/usr/bin/perl
#
# Author:	D. Bierer <doug@unlikelysource.com>
# Date:		27 Jan 2009
# Notes:	None
#

require './ddclient-lib.pl';

&ui_print_header($text{'config_title_sub'},
                 $text{'index_title_main'},
                 undef,
                 "config",
                 undef,
                 0,
                 1,
                 &help_search_link("ddclient", "man", "doc", "google"), 
                 undef, undef, undef);
&ReadParse();

# Start form and HTML
print &ui_form_start( "./config.cgi", "post");

print "<a href='http://www.magicwave-sys.com/' style='text-decoration: none;'>\n";
print "<img src='./images/icon.gif'></a>\n";

# Initialize arrays used by lower levels
&ddclient_select_options();

# Get clean data from environment
my $ref = &ddclient_clean();
%current = %$ref;

# Check to see if there is a protocol and use option
if ( 1 || !$current{'not_first'} ) {

	# Get info from config file
	# my ( $failure, $message, $ref ) = &ddclient_conf_parse_multi();
	my $config_ref = ddclient_conf_parse_multi();
	my $default_ref = ddclient_conf_parse_default();
	
	foreach my $key (keys %{$default_ref}) {
		$config_ref->{$key} = $default_ref->{$key};
	}
	%current = %{$config_ref};
}

# Config choices, etc.
$out_ref = &ddclient_config ();

print '<table border=0>' . "\n";
print '<tr><td width=40><input type=submit name="action" value="' . $text{'button_previous'} . '"></td>';
print '<td>' . $text{'config_previous_button'} . '</td></tr>' . "\n"; 
print '<tr><td width=40><input type=submit name="action" value="' . $text{'button_update'} . '"></td>';
print '<td>' . $text{'config_update_button'} . '</td></tr>' . "\n"; 
print '<tr><td width=40><input type=submit name="action" value="' . $text{'button_validate'} . '"></td>';
print '<td>' . $text{'config_validate_button'} . '</td></tr>' . "\n"; 
print '</table>' . "\n";

print &ui_hidden("not_first", 1);
print &ui_form_end;

if ( $out_ref ) {
	my @output = @$out_ref;
	foreach $line ( @output ) {
		print "<br>$line\n";
	}
}

#DEBUG
#print "<b>IN</b><hr>";
#foreach $key ( keys %in ) {
#	print "<br> $key = $in{$key}\n";
#}
#print "<p><b>CURRENT</b><hr>";
#foreach $key ( keys %current ) {
#	print "<br> $key = $current{$key}\n";
#}

&ui_print_footer("./edit_manual.cgi",$text{'edit_title'});
&ui_print_footer("./index.cgi",$text{'return'});
