#!/usr/bin/perl
#
# Author:	D. Bierer <doug@unlikelysource.com>
# Date:		5 Feb 2009
# Notes:	Show a page for manually editing config files
#			Taken from "sshd" module
#

require './ddclient-lib.pl';
&ReadParse();
&ui_print_header($text{'edit_title'},$text{'index_title_main'},"",undef,1,undef);

%access = &get_module_acl();
if ( $access{'edit'} ) {
	
	# Work out and show the files
	@files = ( $config{'conf1'}, $config{'conf2'} );
	$in{'file'} ||= $files[0];
	&indexof($in{'file'}, @files) >= 0 || &error($text{'error_open_file'});
	print &ui_form_start("edit_manual.cgi");
	print "<b>$text{'edit_file'}</b>\n";
	print &ui_select("file", $in{'file'},
			 [ map { [ $_ ] } @files ]),"\n";
	print &ui_submit($text{'edit_ok'});
	print &ui_form_end();

	# Show the file contents
	print &ui_form_start("save_manual.cgi", "form-data");
	print &ui_hidden("file", $in{'file'}),"\n";
	$data = &read_file_contents($in{'file'});
	print &ui_textarea("data", $data, 20, 80),"\n";
	print &ui_form_end([ [ "save", $text{'edit_save'} ] ]);

	$response = &un_urlize ( $in{'response'} );
	print &html_escape ( $response );

} else {
	&error("$text{'error_not_allowed_to_edit'}");
}

&ui_print_footer("./index.cgi", $text{'return'});
&ui_print_footer("./config.cgi", $text{'config_title_sub'});
