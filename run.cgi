#!/usr/bin/perl
#
# Author:	D. Bierer <doug@unlikelysource.com>
# Date:		22 Jan 2009
# Notes:	None
#

require './ddclient-lib.pl';
&ReadParse(*input);

&ui_print_header($text{'run_title_sub'},$text{'run_title_main'},"",undef,1,undef);

print &ui_form_start( "./run.cgi?$output", "post");

# ddclient {-help}

#       ddclient [-daemon interval] [-proxy host] [-server host] [-protocol type] [-file configfile] [-cache cachefile] [-pid pidfile] [-use mechanism] {-if interface
#                | -ip ipaddress | -web {provider | url} | -fw firewall | -cmd command}


print &ui_buttons_start();
print &ui_buttons_row('./start.cgi',$text{'display_start'}, $text{'display_start_descr'});
print &ui_buttons_row('./stop.cgi',$text{'display_stop'}, $text{'display_stop_descr'});
print &ui_buttons_row('./restart.cgi',$text{'display_restart'}, $text{'display_restart_descr'});
print &ui_buttons_row('./status.cgi',$text{'display_status'}, $text{'display_status_descr'});
print &ui_buttons_row('./force-reload.cgi',$text{'display_force-reload'}, $text{'display_force-reload_descr'});
print &ui_buttons_row('./config.cgi',$text{'display_config'}, $text{'display_config_descr'});
print &ui_buttons_row('./enable.cgi',$text{'display_enable'}, $text{'display_enable_descr'});
print &ui_buttons_row('./disable.cgi',$text{'display_disable'}, $text{'display_disable_descr'});
print &ui_buttons_row('./kill.cgi',$text{'display_kill'}, $text{'display_kill_descr'});
print &ui_buttons_row('./manual.cgi',$text{'display_manual'}, $text{'display_manual_descr'});
print &ui_buttons_end;

print &ui_form_end(), "\n";

print "\n<b>";
print $input{'response'};
print "\n</b>";

&ui_print_footer("./index.cgi",$text{'return'});
