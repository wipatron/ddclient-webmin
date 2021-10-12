#!/usr/bin/perl
#
# Author:	D. Bierer <doug@unlikelysource.com>
# Date:		22 Jan 2009
# Notes:	None
#

require './ddclient-lib.pl';

&ReadParse();

&ui_print_header($text{'display_title_sub'},$text{'display_title_main'},"",undef,1,undef);

print &ui_buttons_start();
print &ui_buttons_row('./start.cgi',$text{'display_start'}, $text{'display_start_descr'});
print &ui_buttons_row('./stop.cgi',$text{'display_stop'}, $text{'display_stop_descr'});
print &ui_buttons_row('./restart.cgi',$text{'display_restart'}, $text{'display_restart_descr'});
print &ui_buttons_row('./status.cgi',$text{'display_status'}, $text{'display_status_descr'});
print &ui_buttons_row('./force-reload.cgi',$text{'display_force-reload'}, $text{'display_force-reload_descr'});
print &ui_buttons_row('./kill.cgi',$text{'display_kill'}, $text{'display_kill_descr'});
print &ui_buttons_row('./manual.cgi',$text{'display_manual'}, $text{'display_manual_descr'});
print &ui_buttons_end;

$list = &get_device_list($in{'iface'},$in{'retries'});
print &ui_columns_start(["IP Address", "MAC Address", "Vendor ID"],100);

foreach ( @$list ) {
    if ( $_ =~ /^(\d+\.\d+\.\d+\.\d+)\s+(\S+:\S+:\S+:\S+:\S+:\S+)\s+(.*)/ ) {
        print &ui_columns_row([$1, $2, $3]);
    }
}

print &ui_columns_end;

&ui_print_footer("./index.cgi",$text{'return'},"./run.cgi",$text{'display_run'});
