#!/usr/bin/perl
#
# Author:	D. Bierer <doug@unlikelysource.com>
# Date:		5 Feb 2009
# Notes:	Show a page for manually editing config files
#			Taken from "sshd" module
#

require './ddclient-lib.pl';
&error_setup($text{'error_failed_to_save'});
&ReadParseMime();

# Work out the file
@files = ( $config{'conf1'}, $config{'conf2'} );
&indexof($in{'file'}, @files) >= 0 || &error($text{'edit_efile'});
$in{'data'} =~ s/\r//g;
$in{'data'} =~ /\S/ || &error($text{'edit_edata'});

# Write to it
&open_lock_tempfile(DATA, ">$in{'file'}");
&print_tempfile(DATA, $in{'data'});
&close_tempfile(DATA);

&webmin_log("modify", undef, $in{'file'});
$output = &urlize ( $text{'successful_conf_file_write'} );
&redirect("edit_manual.cgi?response=$output");
