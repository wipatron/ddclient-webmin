#
# Author:	D. Bierer <doug@unlikelysource.com>
# Date:		27 Jan 2009
# Notes:	None
#

do '../web-lib.pl';
&init_config();
do '../ui-lib.pl';
&foreign_require("proc", "proc-lib.pl");

our %PARSE_REGEXP = (
	'hostname' => '((?:[-\w.]+\.\w+)|\d+)'
);

#
# Programs current set of options
#
sub ddclient_select_options {

	# Program this array with keys and values: add, edit or delete as you see fit
	# 3 = basic; 6 = advanced
	# After that are the parameters (see %valid_options defs below)
	
	%ddclient_nr = (
				'ip'					 => 'ip',
				'if'					 => 'if,if-skip',
				'web'					 => 'web,web-skip',
				'cmd'					 => 'cmd,cmd-skip',
				'fw'					 => 'fw,fw-skip,fw-login,fw-password'
			);

	%ddclient_device = (
				'2wire' 				 => '2Wire 1701HG Gateway',
    			'3com-3c886a' 			 => '3com 3c886a 56k Lan Modem',
    			'3com-oc-remote812' 	 => '3com OfficeConnect Remote 812',
    			'alcatel-510' 			 => 'Alcatel Speed Touch 510',
    			'alcatel-stp' 			 => 'Alcatel Speed Touch Pro',
    			'allnet-1298' 			 => 'Allnet 1298',
    			'cayman-3220h' 			 => 'Cayman 3220-H DSL',
    			'cisco' 				 => 'Cisco FW',
    			'dlink-524' 			 => 'D-Link DI-524',
    			'dlink-604' 			 => 'D-Link DI-604',
    			'dlink-614' 			 => 'D-Link DI-614+',
    			'e-tech' 				 => 'E-tech Router',
    			'elsa-lancom-dsl10' 	 => 'ELSA LanCom DSL/10 DSL FW',
    			'elsa-lancom-dsl10-ch01' => 'LanCom DSL/10 DSL FW (isdn ch01)',
    			'elsa-lancom-dsl10-ch02' => 'ELSA LanCom DSL/10 DSL FW (isdn ch01)',
    			'linksys' 				 => 'Linksys FW',
    			'linksys-rv042-wan1' 	 => 'Linksys RV042 Dual Homed Router WAN Port 2',
    			'linksys-rv042-wan2' 	 => 'Linksys RV042 Dual Homed Router WAN Port 2',
    			'linksys-ver2' 			 => 'Linksys FW version 2',
    			'linksys-ver3' 			 => 'Linksys FW version 3',
    			'linksys-wcg200'         => 'Linksys WCG200 FW',
    			'linksys-wrt854g'        => 'Linksys WRT854G FW',
    			'maxgate-ugate3x00'      => 'MaxGate UGATE-3x00 FW',
    			'netcomm-nb3'            => 'NetComm NB3',
    			'netgear-dg834g'         => 'netgear-dg834g',
    			'netgear-rp614'          => 'Netgear RP614 FW',
    			'netgear-rt3xx'          => 'Netgear FW',
    			'netgear-wgt624'         => 'Netgear WGT624',
    			'netgear-wpn824'         => 'Netgear WPN824 FW',
    			'netopia-r910'           => 'Netopia R910 FW',
    			'olitec-SX200'           => 'olitec-SX200',
    			'rtp300'                 => 'Linksys RTP300',
    			'sitecom-dc202'          => 'Sitecom DC-202 FW',
    			'smc-barricade'          => 'SMC Barricade FW',
    			'smc-barricade-7004vbr'  => 'SMC Barricade FW (7004VBR model config)',
    			'smc-barricade-7401bra'  => 'SMC Barricade 7401BRA FW',
    			'smc-barricade-alt'      => 'SMC Barricade FW (alternate config)',
    			'sohoware-nbg800'        => 'SOHOWare BroadGuard NBG800',
    			'sveasoft'               => 'Sveasoft WRT54G/WRT54GS',
    			'vigor-2200usb'          => 'Vigor 2200 USB',
    			'watchguard-edge-x'      => 'Watchguard Edge X FW',
    			'watchguard-soho'        => 'Watchguard SOHO FW',
    			'web'                    => 'an IP discovery page on the web',
    			'westell-6100'           => 'Westell C90-610015-06 DSL Router',
    			'xsense-aero'            => 'Xsense Aero' 
    			);

	# Program this array with keys and values: add, edit or delete as you see fit
	# Options supported by the protocol are separated by ","
	# Each option must match an entry in "@protocol_options" below
	# Entries with "=" are defaults if none are supplied by user
	
	%protocols = (
					'dyndns2' 		=> "server=members.dyndns.org,login,password,mx,backupmx,wildcard,static,custom" ,
					'concont' 		=> "server=www.dydns.za.net,login,password,mx,wildcard" ,
					'dnspark' 		=> "server=www.dnspark.com,login,password,mx,backupmx,mxpri=10" ,
					'dslreports1' 	=> "server=www.dslreports.com,login,password" ,
					'dyndns1' 		=> "server=members.dyndns.org,login,password,mx,backupmx,wildcard" ,
					'easydns' 		=> "server=members.easydns.com,login,password,mx,backupmx,wildcard" ,
					'hammernode1' 	=> "server=members.dyndns.org,login,password" ,
					'namecheap' 	=> "server=dynamicdns.park-your-domain.com,login,password" ,
					'sitelutions' 	=> "server,login,password,a_record_id",
					'zoneedit1' 	=> "server=www.zoneedit.com,login,password"
				);

	# If adding a protocol to the list above, make sure you add 
	# any new (unique) protocol options to this list
	@protocol_options = ( 	"server",
							"login"	,
							"password",
							"mx",
							"backupmx",
							"mxpri",
							"wildcard",
							"static",
							"custom",
							"unique-number",
							"a_record_id"
							);
	
	# Program this array with keys and values: add, edit or delete as you see fit
	# BOTH Daemon and Usage (command line) modes:
	# Basic:    1 = daemon | usage; 2 = servers and protocols; 3 = routers and IP acquisition
	# Advanced: 4 = daemon | usage; 5 = servers and protocols;
	# DAEMON mode only:
	# Basic:    a = daemon | usage; b = servers and protocols; c = routers and IP acquisition
	# Advanced: d = daemon | usage; e = servers and protocols;
	# USAGE mode only:
	# Basic:    u = daemon | usage; v = servers and protocols; w = routers and IP acquisition
	# Advanced: x = daemon | usage; y = servers and protocols;
	# OTHER: 
	# 7 = Valid option that you don't want to appear onscreen anywhere
	# 8 = /etc/default/ddclient options
	# 9 = used as secondary to %protocols options; not used in command line mode
	# s = used as secondary to %protocols options which should be standalone values
	# VALUES:
	# drop = drop down menu; text = textbox; num = numeric only; file = filebox; 
	# yesno = yes or no only; 01 = 0 or 1 only; TF = true or false only
	# Use type of "yesno" for single options, i.e. "exec" or "noexec"
	
	%valid_options = (
						"timeout" 			=> "1,0,num",
						"mail" 				=> "1,,email",
						"mail-failure" 		=> "1,,email",
						"retry" 			=> "u,no,yesno",
						"ssl" 				=> "5,no,yesno",
						"protocol" 			=> "2,dyndns2,drop",
						"server" 			=> "2,members.dyndns.org,text",
						"host"				=> "v,,text",
						"login" 			=> "2,,text",
						"password" 			=> "2,,text",
						"unique_number"		=> "2,,num",
						"a_record_id"		=> "2,,text",
						"use" 				=> "7,ip,drop",
						"debug" 			=> "u,no,yesno",
						"syslog" 			=> "a,no,yesno",
						"facility" 			=> "a,daemon,text",
						"priority" 			=> "a,notice,text",
						"cache" 			=> "a,$config{'cache1'},file",
						"proxy" 			=> "4,,text",
						"file" 				=> "7,$config{'conf1'},file",
						"verbose" 			=> "u,no,yesno",
						"quiet" 			=> "u,no,yesno",
						"query" 			=> "u,no,yesno",
						"help"				=> "7,0,01",
						"exec" 				=> "x,yes,yesno",
						"force" 			=> "x,no,yesno",
						"daemon" 			=> "a,0,num",
						"run_ipup" 		 	=> "8,false,TF",
						"run_daemon" 		=> "8,false,TF",
						"daemon_interval" 	=> "8,300,num",
						"pid" 				=> "d,,file",
						"ip" 				=> "3,,ip",
						"if" 				=> "3,ppp0,text",
						"if-skip" 			=> "3,,text",
						"web" 				=> "3,dyndns,text",
						"web-skip" 			=> "3,,text",
						"fw" 				=> "3,,text",
						"fw-skip" 			=> "3,,text",
						"fw-login" 			=> "3,,text",
						"fw-password" 		=> "3,,text",
						"cmd" 				=> "3,,file",
						"cmd-skip" 			=> "3,,text",
						"mx"				=> "9,,text",
						"wildcard"			=> "9,,yesno",
						"backupmx"			=> "9,,yesno",
						"static"			=> "9,,yesno",
						"custom"			=> "9,,text",
						"mxpri"				=> "9,10,num"
					);
	
	return;

}

# Kills ddclient process
sub kill_ddclient {
	my $output = "";
	# Check to see if running
	my $b = &backquote_command ( "pgrep ddclient" );
	if ( !$b ) {
		$output = "<br>$text{'display_ddclient_not_running'}";
	} else {
	    $output = &backquote_command ( "pkill ddclient" );
	}
	# Check again to see if running
	$b = &backquote_command ( "pgrep ddclient" );
	if ( $b ) {
	    $output .= &backquote_command ( "pkill -9 ddclient" );
		$output .= "<br>$text{'error_kill_again'}";
	} else {
		$output .= "<br>$text{'successful_pkill'}";
	}
	
	webmin_log("stop", "killed", "");
	
    return &urlize ( $output );
}

sub ddclient_is_running {
	my $config = ddclient_conf_parse_multi();
	my $pid = $config->{'pid'};
	
	return $pid ? check_pid_file($pid) : -1;	
}

# Really kill ddclient
# Inputs: pid
# Outputs: message
#
sub really_kill_ddclient {
	
	my $pid = shift;
	my $output = &backquote_command ( "pkill -9 ddclient" );
	return $output;
	
}

# Display ddclient --help
sub help_ddclient {
	$output = "";
    @help = split ( "\n", `"$config{'exec1'}" --help` );
	foreach $line ( @help ) {
		chomp $line;
		$output .= "<br>" . $line;
	}
    return $output;
}

# Stops ddclient process from running in daemon mode
sub stop_ddclient {
    $output = `"$config{'init1'}" stop`;
    
    webmin_log("stop", "using init script", "");
    
    return &urlize ( $output );
}

# Starts ddclient process in daemon mode
sub start_ddclient {
	$output = `"$config{'init1'}" start`;
	
	webmin_log("start", "using init script", "");
	
    return &urlize ( $output );
}

# Restarts ddclient process using the init script
sub restart_ddclient {
    $output = `"$config{'init1'}" restart`;
    
    webmin_log("restart", "using init script", "");
    
    return &urlize ( $output );
}

# Displays ddclient process status using the init script
sub status_ddclient {
	my $output = "";
    my @data  = split ( "\n", `ps -ax |grep ddclient` );
	foreach $line ( @data ) {
		if ( !($line =~ /webmin/) && !($line =~ /grep/) ) {
			$output .= "<br>" . $line;
		}
	}
	if ( !$output ) {
		$output = $text{'display_ddclient_not_running'};
	}
    return $output;
}

# Resets config files to default
sub reset_ddclient {
	
	my $output = "";
	# Clean up input
	my $ref1 = &ddclient_clean();
	my %current = %$ref1;
	my $action = $current{'action'};

	if ( $action =~ /$text{'button_reset'}/ ) {

		# Copies /etc/webmin/ddclient/ddclient.conf.original to /etc/ddclient.conf
		$dest 	= $config{'conf1'};
		$src	= $module_config_directory . "/" . &ddclient_just_filename ( $dest ) . ".original";
		if ( &copy_source_dest ( $src, $dest ) ) {
			$output = $text{'successful_reset'} . $src . " to " . $dest;
			%log_info = ( "modify" => "$output" );
			&webmin_log("modify", "module", $config{'conf1'}, \%log_info);
		} else {
			$output = $text{'error_reset'} . $src . " to " . $dest;
			%log_info = ( "error" => "$output" );
			&webmin_log("error", "module", $config{'conf1'}, \%log_info);
		}


		# Copies /etc/webmin/ddclient_daemon.original to /etc/default/ddclient
		$dest 	= $config{'conf2'};
		$src	= $module_config_directory . "/" . &ddclient_just_filename ( $dest ) . "_daemon.original";
		if ( &copy_source_dest ( $src, $dest ) ) {
			$output .= "<br>" . $text{'successful_reset'} . $src . " to " . $dest;
			%log_info = ( "modify" => "$output" );
			&webmin_log("modify", "module", $config{'conf2'}, \%log_info);
		} else {
			$output .= "<br>" . $text{'error_reset'} . $src . " to " . $dest;
			%log_info = ( "error" => "$output" );
			&webmin_log("error", "module", $config{'conf2'}, \%log_info);
		}

	}
	
    return $output;

}

#
# Enables or Disables ddclient running as a daemon
# Inputs: $setting = 'true' to run as a daemon, 'false' otherwise
#
sub enable_disable_ddclient {
	
	# Get setting
	my $setting		= shift;
	
	# Initialize variables
	my $failure 	= 1;
	my $output 		= "";
	my $info 		= "";
	my $cmd 		= "";
	my @contents 	= ();
	my $conf_file	= $config{'conf2'};		# Daemon config script /etc/default/ddclient
	my $bak_file	= $module_config_directory . "/" . &ddclient_just_filename ( $conf_file ) . ".daemon.conf.wbm_bak";
	my $tmp_file	= $module_config_directory . "/" . sprintf ( "%08d", int ( rand ( 99999999 ) ) ) . ".tmp";
	my $init_script = &ddclient_just_filename ( $config{'init1'} );			
	
	# Read /etc/ddclient.conf
	if ( open ( my $fh, "<", $conf_file ) ) {

		while ( my $line = <$fh> ) {
			chomp $line;
			if ( ! ( $line =~ /^run_daemon/ ) ) {
				push ( @contents, $line );
			}
		}

		# Set line with run_daemon to true
		push ( @contents, 'run_daemon=' . $setting );

		close $fh;
		
		# Write to temp file
		if ( open ( my $fh, ">", $tmp_file ) ) {

			# Print comment lines
			foreach $line ( @contents ) {
				print $fh $line . "\n";
			}

			close $fh;			

			# If the bak file exists, delete it
			if ( unlink ( $bak_file ) ) {
				$output .= "<br>" . $text{'successful_bak_delete'} . "<br>";
			}

			# Rename config file to bak
			if ( &rename_logged( $conf_file, $bak_file ) ) {

				# Rename temp file to config file
				if ( &rename_logged( $tmp_file, $conf_file ) ) {

					$output .= $text{'successful_change_write'};
					$failure = 0;

				} else {
					$output .= $text{'error_write_file'} . $conf_file . " - " . $!;
				}

			} else {
				$output .= $text{'error_write_file'} . $bak_file . " - " . $!;
			}

		} else {
			$output .= $text{'error_write_file'} . $tmp_file . " - " . $!;
		}

	} else {
		$output .= $text{'error_open_file'} . $conf_file . " - " . $!;
	}

	# Check for failure
	if ( $failure ) {

		# Log failure
		%log_info = ( "error" => "$output" );
		&webmin_log("error", "module", $config{'conf2'}, \%log_info);

	} else {

		# Log success
		%log_info = ( "success" => "$output" );
		&webmin_log("apply", "module", $config{'conf2'}, \%log_info);

		# Modify RCx.d environment
		if ( $setting =~ /^true/ ) {
			# i.e. /usr/sbin/update-rc.d barnyard defaults
			# This will create start links in rc[2345] and kill links in rc[016]
			$cmd = $config{'exec2'} . " " . $init_script . " defaults";
		} else {
			# i.e. /usr/sbin/update-rc.d barnyard remove
			$cmd = $config{'exec2'} . " -f " . $init_script . " remove";
		}

		$output .= "<br>" . $cmd;

		@contents = split ( "\n", &backquote_logged ( $cmd ) );
		foreach $line ( @contents ) {
			chomp $line;
			$output .= "<br>" . $line;
		}
		&webmin_log("modify");

	}

    return &urlize ( $output );

}

#
# Inputs:	$string
# Outputs:	$string with \' and \"
#
sub add_slash {
	
	my $input = shift;
	$input =~ s/(['"])/\\$1/g;
	return $input;
}

#
# Inputs:	$string with \' and \"
# Outputs:	$string
#
sub strip_slash {
	
	my $input = shift;
	$input =~ s/\\'/'/g;
	$input =~ s/\\"/"/g;
	return $input;
}

#
# Reads a config file
# Inputs: 	$filename = name of config file to read
# Outputs: 	$failure = 0 if OK, 1 if problem, $message = error messages (if any), @contents = each element = line in the config file
#
sub ddclient_read_config_file {

	# Get input filename
	my $filename = shift;
	
	# Initialize variables
	my @contents = ();
	my $failure = 0;
	my $message = "";
	
	# Open file
	if ( open ( my $fh, "<", $filename ) ) {
		while ( my $line = <$fh> ) {
			chomp $line;
			push ( @contents, $line );
		}
		close $fh;
	} else {
		$failure++;
		$message = $text{'error_open_file'} . " - " . $filename . " - " . $!;
	}	

	return ( $failure, $message, \@contents );	

}

sub ddclient_config_backup {
	my $infile = shift;
	
	if (!-r $infile) {
		return 0;
	}
	
	# Split off filename
	my $filename = &ddclient_just_filename ( $infile );
	
	# Filenames
	my $bak_file	= $module_config_directory . "/" . $filename . ".wbm_bak";
	
	# If the bak file exists, delete it
	unlink ( $bak_file );
		
	copy_source_dest($infile, $bak_file);
	
	return 1;
}

#
# Backs up and writes a config file 
# Inputs: 	$filename = name of config file to written, $ref = reference to @contents to be written
# Outputs: 	$failure = 0 if OK, 1 if problem, $output  = error messages (if any)
#			Produces a file = /etc/webmin/ddclient/$filename.wbm_bak & writes $filename
#
sub ddclient_write_config_file {

	# Get input filename
	my $infile = shift;
	my $ref	= shift;
		
	# Initialize variables
	my @contents = @$ref;
	my $failure = 0;
	my $output = "";
	
	# Filenames
	my $tmp_file	= $module_config_directory . "/" . sprintf ( "%08d", int ( rand ( 99999999 ) ) ) . ".tmp";

	# Open temp file for write
	if ( open ( my $fh, ">", $tmp_file ) ) {
		foreach my $line ( @contents ) {
			print $fh $line . "\n";
		}
		close $fh;

		# Rename config file to bak
		if ( ddclient_config_backup($infile) ) {

			# Rename temp file to config file
			if ( &rename_file( $tmp_file, $infile ) ) {

				$output .= $text{'successful_change_write'};

			} else {
				$output .= $text{'error_write_file'} . $infile . " - " . $!;
			}
			
		} else {
			# Rename temp file to config file
			if ( &rename_file( $tmp_file, $infile ) ) {

				$output .= $text{'successful_change_write'};

			} else {
				$output .= $text{'error_write_file'} . $infile . " - " . $!;
			}
		}

	} else {
		$failure++;
		$output .= $text{'error_write_file'} . $tmp_file . " - " . $!;
	}	

	return ( $failure, $output );	

}

#
# Inputs:	$full_filename = full path to filename (i.e. /etc/webmin/ddclient/ddclient.daemon.conf.wbm_bak )
# Outputs	$just_name	   = only filename, no path (ddclient.daemon.conf.wbm_bak )
#
sub ddclient_just_filename {

	$full_filename = shift;
	
	# Split off filename
	@data = split ( "\/", $full_filename );

	return pop @data;
		
}

#
# Inputs:	None
# Outputs:	Icons printed to browser
#
sub ddclient_display_icons {
	
	# Set up tabs
	 @tabs = ( [ 'basic', $text{'display_basic'} ],
			   [ 'advanced', $text{'display_advanced'} ]
			 );

	# Daemon Control
	print &ui_tabs_start(\@tabs, 'tab_mode', 'basic');

	my $links1_op = [  
				'./status.cgi',
				'./show_services.cgi',
				'./add_service.cgi?type=service',				
				'./config.cgi',
				'./log.cgi'
				];

	my $titles1_op = [ 
				$text{'display_status'},
				$text{'display_services'},
				$text{'display_add_service'},
				$text{'display_config'},
				$text{'display_log'}
				];

	my $icons1_op = [ 
				'./images/status.png',
				'./images/hostnames.png',
				'./images/hostnames_add.png',
				'./images/config.png',
				'./images/log.png',
				'./images/help.png'
				];

	print &ui_tabs_start_tab('tab_mode', 'basic');

	&icons_table( $links1_op , $titles1_op , $icons1_op );

	print &ui_tabs_end_tab('tab_mode', 'basic');

	# Manual IP Update
	my $links2 = [
				'./manual.cgi',
				'./edit_manual.cgi',
				'./enable.cgi',
				'./disable.cgi'				
				];

	my $titles2 = [ 
				$text{'display_manual'},
				$text{'display_edit_manual'},
				$text{'display_enable'},
				$text{'display_disable'}
				];

	my $icons2 = [ 
				'./images/manual.png', 
				'./images/config.png',
				'./images/enable.png', 
				'./images/disable.png'				
				];

	print &ui_tabs_start_tab('tab_mode', 'advanced');
	&icons_table( $links2 , $titles2 , $icons2 );
	print &ui_tabs_end_tab('tab_mode', 'advanced');

	print &ui_tabs_end();	
	
	my $running = ddclient_is_running();
		
	print ui_buttons_start();
	
	my $status = $running > 0 ? $text{'index_status_running'} : 
		($running == -1) ? $text{'index_status_pid_config'} : $text{'index_status_stopped'}; 
		
	print text('index_status_msg', "<tt>$status</tt>");
	
	if ($running == -1) {
		print '<br/>' .  text('index_status_pid_config_desc');
	}
	else {
		if (!$running) {
			print ui_buttons_row("start.cgi", $text{'display_start'}, 
				$text{'display_start_descr'});
		}
		else {
			print ui_buttons_row("restart.cgi", $text{'display_restart'}, 
				$text{'display_restart_descr'});
			print ui_buttons_row("stop.cgi", $text{'display_stop'}, 
				$text{'display_stop_descr'});
		}
	}
	print ui_buttons_row("kill.cgi", $text{'display_kill'}, $text{'display_kill_descr'});
	print ui_buttons_end();
	
	if ( $in{'response'} ) {
		print '<div style="border: thin dashed black">';
		print "\n<p><b>RESPONSE:</b><br><i>";
		print &un_urlize ( $in{'response'} );
		print "\n</i></p>";
		print '</div>';
	}
}

#
# Inputs:	None
# Outputs:	ddclient version
#
sub ddclient_version {
	
	$output = `ddclient --help | grep "ddclient version"`;
	$output =~ s/,//g;
	return $output;
	
}

#
# Inputs:	%in = global which contains environment
# Outputs:	$outref = ref to %clean = %in cleaned up
#
sub ddclient_clean {

#	my %clean = {};
	
#	foreach my $key ( keys %in ) {		
#		my $a = &un_urlize ( $in{"$key"} );
#		$clean{"$key"}	= $a;
#	}

	return \%in;

}

#
# Inputs:	None
# Outputs:	Icons printed to browser
#
sub ddclient_prev_config {

	my $output = "";
	my $failure = 0;

	# Copies /etc/webmin/ddclient/ddclient.conf.original to /etc/ddclient.conf
	my $dest 	= $config{'conf1'};
	my $src	= $module_config_directory . "/" . &ddclient_just_filename ( $dest ) . ".wbm_bak";
	if ( &copy_source_dest ( $src, $dest ) ) {
		$output = $text{'successful_reset'} . $src . " to " . $dest;
	} else {
		$output = $text{'error_reset'} . $src . " to " . $dest;
		$failure++;
	}

	# Copies /etc/webmin/ddclient_daemon.original to /etc/default/ddclient
	$dest 	= $config{'conf2'};
	$src	= $module_config_directory . "/" . &ddclient_just_filename ( $dest ) . ".daemon.conf.wbm_bak";
	if ( &copy_source_dest ( $src, $dest ) ) {
		$output .= "<br>" . $text{'successful_reset'} . $src . " to " . $dest;
	} else {
		$output .= "<br>" . $text{'error_reset'} . $src . " to " . $dest;
		$failure++;
	}

    return ( $failure, &urlize ( $output ) );

}

#
# Inputs:	%in = global environment
# Outputs:	Backs up then writes updates to daemon file (/etc/default/ddclient)
#
sub ddclient_update_daemon_file {
	# Initialize variables
	my $ref = &ddclient_clean();
	my $response = "";
	my $message = "";
	my $failure = 0;
	my @output = ();
				
	# Add autogenerate info
	my $date = `date`;
	push ( @output, "# Generated by Webmin ddclient module" );
	push ( @output, "# " . $date );
		
	# Scan for tags beginning with "new_" but not server, login, etc.
	while ( ( $key, $value ) = each ( %valid_options ) ) {
		# Filter for daemon options
		if ( $value =~ /^8/ && $in{$key} ) {
			push ( @output, $key . "=" . $in{$key} );
			$current{$key} = $in{$key};
		}
	}	

	( $failure, $message ) = &ddclient_write_config_file ( $config{'conf2'}, \@output );
	if ( $failure ) {
		$response .= "<br>" . $message;
	} else {					
		# Let user know wuzzup
		$response = $text{'successful_daemon_file_write'};
	}

	return ( $failure, $response );
	
}

#
# Inputs:	%config = module config file
# Outputs:	Restores command line file from previous backup file
#			and then deletes the backup file
#			If backup file not found, restores from %config
#
sub ddclient_prev_cmd_line {

	my $output	= "";

	# Destination = /etc/webmin/ddclient/ddclient_cmd_line_params.txt
	$dest 	= $config{'cmd2'};
	# Source = /etc/webmin/ddclient/ddclient_cmd_line_params.txt.wbm_bak
	$src	= $module_config_directory . "/" . &ddclient_just_filename ( $dest ) . ".wbm_bak";

	# Check for existence of backup file
	if ( -r $src ) {

		if ( &copy_source_dest ( $src, $dest ) ) {
			$output = $text{'successful_reset'} . $src . " to " . $dest;
		} else {
			$output = $text{'error_reset'} . $src . " to " . $dest;
		}

	} else {

		# Write default command line params into save file
		( $failure, $output ) = &ddclient_save_cmd_line ( $config{'cmd1'} );

	}
		
	return $output;

}

#
# Inputs:	$cmd_line, %config = module config info
# Outputs:	/etc/webmin/ddclient/ddclient_cmd_line_params.info ($config{'cmd2'})
#
sub ddclient_save_cmd_line {

	# Initialize variables
	my @contents	= @_;		# i.e. $cmd_line
	my $failure	= 0;
	my $message	= "";
	my $ref;
	my $cmd_file	= $config{'cmd2'};
				
	# Write command line parameters to file
	( $failure, $message, $ref ) = &ddclient_write_config_file ( $cmd_file, \@contents );

	if ( !$failure ) { $message .= "<br>" . $text{'manual_cmd_line_saved'}; }

	return ( $failure, $message );

}

#
# Inputs:	$type = TF | 01 | yesno, $value = 1 | 0 
# Outputs:	true/false, 0/1, yes/no
#
sub ddclient_type {
	
	my $type = shift;
	my $value = shift;
	my $result = "";
	
	if ( $type eq "TF" ) {
		if ( $value ) { 
			$result = $text{'true'}; 
		} else { 
			$result = $text{'false'}; 
		}
	} elsif ( $type eq "01" ) { 
		$result = $value; 
	} else {
		if ( $value ) { 
			$result = $text{'yes'}; 
		} else { 
			$result = $text{'no'}; 
		}
	}
	
	return $result;
	
}

#
# Inputs:	$key, $value; Module global = %protocols, %ddclient_device, %valid_options
# Outputs:	$valid = 1 if valid; 0 if not; $message = informative message about error
#
sub ddclient_validate {

	# Get inputs
	my ( $key, $value ) = @_;
	my $valid = 0;
	my $message = "";
	
	# If there's no value, not worth bothering about!
	if ( length ( $value ) == 0 ) {
		$valid = 1;
	} else {
		# Check to see if $key = interface
		if ( $key =~ /^use$/ ) {
			if ( $ddclient_device{$value} ) {
				$valid = 1;
			} elsif ( $ddclient_nr{$value} ) {
				$valid = 1;
			} else {
				$message = "&nbsp;" . $text{'error_device'} ;
			}			

		# Check to see if $key = protocol
		} elsif ( $key =~ /^protocol$/ ) {
			if ( $protocols{$value} ) {
				$valid = 1;
			} else {
				$message = "&nbsp;" . $text{'error_protocol'} ;
			}
		# Check "if"
		} elsif ( $key =~ /^if$/ ) {
			if ( $value =~ /\w+\d+/ ) {
				$valid = 1;
			} else {
				$message = "&nbsp;" . $text{'error_if'} ;
			}
		# If "file" option, check to see if file exists
		} elsif ( $valid_options{$key} =~ /file$/ ) {
			# Do not check the PID file for existence, it will be created by ddclient
			if ( -r $value || $key eq 'pid' ) {
				$valid = 1;
			} else {
				$message = "&nbsp;" . $text{'error_file_not_found'} ;
			}
		# If "num" option, check to see if numeric
		} elsif ( $valid_options{$key} =~ /num$/ ) {
			if ( $value =~ /\d+/ ) {
				$valid = 1;
			} else {
				$message = "&nbsp;" . $text{'error_must_be_number'} ;
			}
		# If "ip" option, check to see if in form a.b.c.d
		} elsif ( $valid_options{$key} =~ /ip$/ ) {
				
			$value =~ s/\./,/g;
			my @vals = split ( ',', $value );
			my $ok = 0;
			foreach my $n ( @vals ) {

				if ( $n >= 0 && $n <= 255 ) {
					$ok++;
				}
			}
			if ( $ok == 4 ) {
				$valid = 1;
			} else {
				$message = "&nbsp;" . $text{'error_invalid_ip'} ;
			}
		# If "email" option, check to see if in the form x@y
		} elsif ( $valid_options{$key} =~ /email$/ ) {
			if ( $value =~ /\@/ ) {
				$valid = 1;
			} else {
				$message = "&nbsp;" . $text{'error_email'} ;
			}
		# Can't think of anything else ... just let it go
		} else {
			$valid = 1;
		}
	}
			
	return ( $valid, $message );

}

#
# Inputs:	$cmd_line
# Outputs:	$response = HTML for incorrect options; blank if OK
#
sub ddclient_validate_cmd_line {

	# Initialize variables
	my $cmd_line = shift;
	my $failure = 0;
	my $error = "";
	my $ref;			
	
	# Parse command line into hash %current
	( $error, $ref ) = &ddclient_parse_cmd_line ( $cmd_line );	

	if ( !$error ) {
		$error = $text{'valid_ok'};
	} else {
		$failure++;
	}
	
	return ( $failure, $error );
		
}

#
# Adds -verbose -debug and -noexec to $cmd_line
# Inputs:	$cmd_line
# Outputs:  $test_cmd_line
#
sub ddclient_test_cmd_line {
	
	my $test_line = shift;
	my $exec = shift;

	# Strip out any -verbose -noverbose -exec -noexec -debug -nodebug
	$test_line =~ s/-help//;
	$test_line =~ s/-verbose//;
	$test_line =~ s/-noverbose//;
	$test_line =~ s/-debug//;
	$test_line =~ s/-nodebug//;
	$test_line =~ s/-exec//;
	$test_line =~ s/-noexec//;
	$test_line =~ s/-daemon=\d+//;
	$test_line .= " -noexec -verbose";
				
	return $test_line;
}

#
# Inputs:	$cmd_line = command string
# Outputs:	$output = result from command
#
sub ddclient_manual_run {
	
	my $cmd_line = shift;
	my $result = "&nbsp;";
	
	$cmd_line .= " -debug -daemon=0";
	
	warn("gonna run: $cmd_line");
		
	my $exec_string = $config{'exec1'} . " " . $cmd_line;
	my @output = split ( "\n", &backquote_logged("($exec_string -file=$module_config_directory/empty_config) 2>&1") );
	&webmin_log("run", undef, undef, { 'cmd' => $exec_string });

	foreach ( @output ) {
		$result .= "<br>" . $_;
	}
		
	return $result;
	
}

# ddclient logs
#
# Inputs: "action" or "syslog"
# Outputs: Contents of those log files
#
sub log_ddclient {

	# Clean up input
	my $ref1 = &ddclient_clean();
	my %current = %$ref1;
	my $output = $current{'response'};	
	my $action = $current{'action'};
	my @input = ();
	my $from_month = 0;
	my $from_day = 1;
	my $to_month = 11;
	my $to_day = 31;
	my $action_log_cmd = "cat $config{'cache1'}";
	my $lines = 20;
	my $filter = "";
		
	# Print action log
	@headings = ( $text{'heading_cache_file'} );	
	print &ui_columns_start(\@headings);
	print "<tr><td>";
	foreach my $line ( &backquote_command ( $action_log_cmd ) ) {
		print "<br>" . $line;
	}
	print "</td></tr>\n";
	print &ui_columns_end;

	# Log file
	my $log_file = $config{'log1'} . "/" . "syslog";

	# Check to see if log file exists
	if ( ! -r $log_file ) {

		$output = $log_file . " " . $text{'error_logfile_not_found'};
		$log_file  = $config{'log1'} . "/" . &ddclient_just_filename ( $config{'exec1'} );		

	} else {
		
		# If not, check to see if user configured path + "ddclient" logfile exists
		if ( ! -r $log_file ) {

			$output .= "<br>" . $log_file . " " . $text{'error_logfile_not_found'};

		} else {

		# No. lines
		$lines = $current{'lines'} ? int($current{'lines'}) : 20;
		
		# Start form and HTML
		print &ui_form_start( "./log.cgi", "post");
		print &ui_table_start($text{'heading_log_options'}, "width=100%", 2);
		print "$text{'log_view_last'} &nbsp;" . &ui_textbox("lines", $lines, 3) . "&nbsp; $text{'log_lines_of'} &nbsp;";
		print "<tt>" . &html_escape($log_file) . "</tt>\n";
		print "&nbsp;&nbsp;\n";
		if ( $current{'def_filter'} ) { 
			$filter = "ddclient";
			print &ui_checkbox("def_filter", 1, undef, 1); 
		} else { 
			$filter = $current{'filter'};
			print &ui_checkbox("def_filter", 1, undef, 0); 
		}
		print $text{'log_view_filter'} . "&nbsp;or&nbsp;" . &ui_textbox("filter", "$filter", 25);
		print "&nbsp;&nbsp;<input type=submit value='$text{'log_view_refresh'}'>\n";
		print &ui_form_end;

		print "<pre><p>";

		# Just the one log
		my $cat = "cat " . quotemeta( $log_file );
		$filter = quotemeta ( $filter );

		if ( $filter ) {
			foreach ( &foreign_call("proc", "safe_process_exec", 
			"$cat | tail -n $lines | grep -i $filter ", 0, 0, STDOUT, undef, 1, 0, undef, 1) ) {
				print "<br>" . $_ ;
			}
		} else {
			foreach ( &foreign_call("proc", "safe_process_exec", 
			"$cat | tail -n $lines ", 0, 0, STDOUT, undef, 1, 0, undef, 1) ) {
				print "<br>" . $_;
			}
		}

		print "</p></pre>\n";
		print &ui_form_start( "./log.cgi", "post");
		print "$text{'log_view_last'} &nbsp;" . &ui_textbox("lines", $lines, 3) . "&nbsp; $text{'log_lines_of'} &nbsp;";
		print "<tt>" . &html_escape($log_file) . "</tt>\n";
		print "&nbsp;&nbsp;\n";
		if ( $current{'def_filter'} ) { 
			$filter = "ddclient";
			print &ui_checkbox("def_filter", 1, undef, 1); 
		} else { 
			$filter = $current{'filter'};
			print &ui_checkbox("def_filter", 1, undef, 0); 
		}
		print $text{'log_view_filter'} . "&nbsp;or&nbsp;" . &ui_textbox("filter", "$filter", 25);
		print "&nbsp;&nbsp;<input type=submit value='$text{'log_view_refresh'}'>\n";
		print &ui_form_end;
		print &ui_table_end();

	}
}
	
	print &ui_form_start( "./log.cgi", "post");
	if ( $output ) { print "<tr><td colspan=2>$output</td></tr>\n"; }
	print "&nbsp;&nbsp;<input type=submit value='$text{'log_view_refresh'}'>\n";
	print &ui_form_end;

    return 1;

}

#
# Sets up HTML rows for ddclient manual operations
# Inputs:	$key = current option being filtered, $value of $key (from %valid_options)
# Globals:  %current, %ddclient_device, %valid_options, %protocols
# Outputs:	Prints HTML
#
sub ddclient_manual_options_row {

	my $key = shift;
	my $value = shift;
	my $do_nothing = 0;
	my $default = "";
	my ( $a, $b );
	
	# Find default -- first time only
	if ( $current{$key} ) {
		$default = $current{$key};
	} elsif ( !$current{'not_first'} ) {
		($a, $default, $b ) = split ( ",", $value );
	}
			
	print "<tr><th align=left>" . $key . "</th><td>";
	# Filter out "use" and "protocol"
	if ( $key =~ /^use/ || $key =~ /^protocol/ ) {
		# Do nothing
		$do_nothing++;
	} elsif ( $value =~ /text$/ ) {
		print &ui_textbox($key, $default, 30, 0, 64);
	} elsif ( $value =~ /email$/ ) {
		print &ui_textbox($key, $default, 30, 0, 64);
	} elsif ( $value =~ /ip$/ ) {
		print &ui_textbox($key, $default, 30, 0, 64);
	} elsif ( $value =~ /num$/ ) {
		print &ui_textbox($key, $default, 8, 0, 16);
	} elsif ( $value =~ /file$/ ) {
		print &ui_filebox($key, $default, 30, 0, 64);
	} elsif ( $value =~ /01$/ ) {
		print &ui_yesno_radio($key, $default);
	} elsif ( $value =~ /yesno$/ ) {
		@yes = ( $text{'yes'}, $text{'yes'} );
		@no = ( $text{'no'}, $text{'no'} );
		@array = ( \@yes, \@no );
		print &ui_radio($key, $default, \@array );
	} elsif ( $value =~ /TF$/ ) {
		@yes = ( $text{'true'}, $text{'true'} );
		@no = ( $text{'false'}, $text{'false'} );
		@array = ( \@yes, \@no );
		print &ui_radio($key, $default, \@array );
	}
	$tag = "config_" . $key;
	print "</td><td>" . $text{"$tag"} . "</td></tr>\n";
}

#
# Inputs:	$mode = "validate" = don't write file
# Global:	%in = global environment; %valid_options = module global
# Outputs:	Writes updates to conf files
#
sub ddclient_conf_update {

	# Get mode
	my $mode = shift;
	
	# Initialize variables
	my $response = "";
	my $message = "";
	my $valid = 1;
	my $failure = 0;
	my @output = ();
	my @data = ();
	my $item;
	my $nothing = 0;
	my $use = "";
	my $required = " ";
								
	# Scan through valid options
	while ( ( $key, $value ) = each ( %valid_options ) ) {
		# Filter out /etc/default/ddclient, secondary options, and protocol/server/login options
		if ( $value =~ /^[14]/ ) {

			# Check to see if any value is set
			$item = $in{$key};

			if ( $item )  {
				( $valid, $message ) = &ddclient_validate ( $key, $item );
				if ( $valid ) {
					$current{$key} = $item;
				} else {
					$failure++;
					$response .= "<br>" . "$key=" . $item . " " . $message;
				}
			}
			else {
				delete $current{$key};
			}
		}
	}	

	# Build a list of required parameters
	#while ( ( $key, $value ) = each ( %valid_options ) ) {
	#	if ( $value =~ /^2/ ) {
	#		$required .= $key . " ";
	#	}
	#}
	
	# Test for "custom" which is an option of the dyndns2 protocol
	# if ( $current{'custom'} ) {
	#	push ( @output, "custom=" . $current{'custom'}  );
	#}
	
	# Create a login from default values if they add up
	#if ( $current{'protocol'} ) {
	#	push ( @output, "protocol=" . $current{'protocol'} . ", \\" );
	#}
				
	if ( $mode eq "validate" ) {

		if ( !$failure ) {
			# Let user know wuzzup
			$response .= $text{'successful_validation'};
		}

	} else {

		# Write changes to /etc/ddclient.conf
		if ( !$failure  ) {

			( $failure, $message ) = &ddclient_config_save_multi ( \%current, $config{'conf1'} );
			
			if ( $failure ) {
				$response .= "<br>" . $message;
			} else {					
				# Let user know wuzzup
				$response .= $text{'successful_conf_file_write'};
			}

		}
	
	}

	return ( $failure, $response, \@output );

}

#
# Sets up HTML "use=" dropdown box
# Inputs:	None
# Globals:  %current, %ddclient_device, %valid_options, %protocols
# Outputs:	Prints HTML
#
sub ddclient_use_dropdown {

	my $key = "use";
	my ( $device, $tag, $sub_key );
	
	print "<select name=$key>\n";
	# Put selected option at top if it exists
	if ( $current{"$key"} ) {
		# Check to see if it's in %ddclient_nr
		if ( $ddclient_nr{$current{"$key"}} ) {
			$tag = "config_" . $current{"$key"};
			$device = $text{$tag};
		} else {
			$device = $ddclient_device{$current{$key}};
		}
		print '<option value="' . $current{$key} . '" selected>' . $device . "</option>\n";
	} else {
		# Default to "ip"
		$current{$key} = "ip";
		$tag = "config_" . $current{"$key"};
		$device = $text{$tag};
		print '<option value="' . $current{$key} . '" selected>' . $device . "</option>\n";
	}
	# Print list of devices programmed into %ddclient_nr above
	print "<optgroup label='Non Router'>\n";
	foreach $sub_key ( sort ( keys %ddclient_nr ) ) {
		my ( $b, @c ) = split ( ",", $ddclient_nr{"$sub_key"} );
		$tag = "config_" . $b;
		$device = $text{$tag};
		if ( $b ne $current{$key} ) {
			print '<option value="' . $b . '">' . $device . "</option>\n";
		}
	}
	print "</optgroup>\n";
	# Print list of devices programmed into %ddclient_device above
	print "<optgroup label='Supported Devices'>\n";
	foreach $sub_key ( sort ( keys %ddclient_device ) ) {
		if ( $sub_key ne $current{$key} ) {
			print '<option value="' . $sub_key . '">' . $ddclient_device{"$sub_key"} . "</option>\n";
		}
	}
	print "</optgroup>\n";
	print "</select>\n";

}

#
# Sets up HTML "protocol=" dropdown box
# Inputs:	None
# Globals:  %current, %protocols
# Outputs:	Prints HTML
#
sub ddclient_protocol_dropdown {

	my $key = "protocol";
	my ( $device, $tag, $sub_key );

	# Check to make sure current protocol is on the list
	my $protocol = $current{"$key"};
	if ( !$protocols{$protocol} ) {
		$protocol = "dyndns2";
	}
	
	print "<select name=$key>\n";
	# Put selected option at top if it exists
	print '<option selected>' . $protocol . "</option>\n";
	# Print list of devices programmed into %protocols above
	foreach $sub_key ( sort ( keys %protocols ) ) {
		if ( $sub_key ne $protocol ) {
			print '<option>' . $sub_key . "</option>\n";
		}
	}
	print "</select>\n";

}


#
# Inputs:	$filename = file to read (normally /etc/ddclient.conf)
# Globals:	%config = module config = names of conf files; %valid_options = module global; %protocols
# Outputs:	$ref = ref to %params = { "param" => "value" }
#
sub ddclient_conf_parse {

	my $in_file = shift;
	my %tmp = {};
	my $response = "";
	my $failure = 0;
	my @contents = ();
	my @data = ();
	my $ref;
	my $ref2;
	my $do_nothing = 0;
	my $options = "";
	my $protocol = "dyndns2";	# Default protocol
	my $item;
					
	# Read /etc/ddclient.conf
	if ( !$in_file ) { $in_file = $config{'conf1'}; }
	
	( $failure, $message, $ref ) = &ddclient_read_config_file ( $in_file );

	if ( $failure ) {

		$response .= "<br>" . $message;

	} else {
			
		# Store contents of /etc/ddclient.conf
		@contents = @$ref;
		
		# Read /etc/default/ddclient = daemon settings
		( $failure, $message, $ref2 ) = &ddclient_read_config_file ( $config{'conf2'} );
			
		if ( $failure ) {

			$response .= "<br>" . $message;

		} else {

			$response .= "<br>" . $text{'successful_read'};
			
			# Store contents of /etc/default/ddclient
			@tmp = @$ref2;
			push ( @contents, @tmp );
			my $x = 0;						# Used for numbering logins
			
			# Scan through contents one line at a time
			foreach $line ( @contents ) {

				# If line contains "#" strip off everything after that point
				$n = index ( $line, "#" );
				if ( $n ge 0 ) {
					$line = substr ( $line, 0, $n );
				}

				# Eliminate leading and trailing white space, quotes, and trailing "\"
				$line =~ s/^\s+//;
				$line =~ s/\s+$//;
				$line =~ s/\"//g;
				$line =~ s/\s*\=\s*/\=/g;
				$line =~ s/\\//;
												
				# Only check if something is there!
				if ( $line ) {

					# Check for lines with both equal signs and commas
					if ( $line =~ /^custom/ ) {
							( $a, $b ) = split ( "=", $item );
							$b =~ s/^\s+//;
							$b =~ s/\s+$//;
							$tmp{'custom'} = $b;
						
					# Check for lines with both equal signs and commas
					} elsif ( ($line =~ /\=/) && ($line =~ /,/) ) {
						my @data = split ( ",", $line );
						foreach my $item ( @data ) {
							if ( $item ) {
								( $a, $b ) = split ( "=", $item );
								if ( $a ) {
									$b =~ s/^\s+//;
									$b =~ s/\s+$//;
									$a =~ s/^\s+//;
									$a =~ s/\s+$//;
									# Puts quotes around value if spaces
									if ( $b =~ /\s/ ) {
										$b = '"' . $b . '"';
									}
									$tmp{$a} = $b;
								}			
							}			
						}

					# Check for comment lines
					} elsif ( $line =~ /^#/ ) {

						# Do nothing
						$do_nothing++;
						
					# Check for lines with an "="
					} elsif ( $line =~ /=/ ) {

						# Split two sets of arguments
						( $a, $b ) = split ( "=", $line );
						$b =~ s/^\s+//;
						$b =~ s/\s+$//;
						$a =~ s/^\s+//;
						$a =~ s/\s+$//;
						# Puts quotes around value if spaces
						if ( $b =~ /\s/ ) {
							$b = '"' . $b . '"';
						}
						# Returns lowercase parameter
						$tmp{$a} = lc ( $b );
						
						# Check to see if protocol specific
						if ( $valid_options{$a} =~ /^9/ ) {
							$options .= $b . ",";
						}

					# Otherwise assume it's a host
					} else { 

						# Find what it's called for this protocol
						if ( $tmp{'protocol'} ) {
							$protocol = $tmp{'protocol'};
						}
						@data = split ( ",", $protocols{$protocol} );
						$a = pop @data;
						if ( !$a ) {
							$a = pop @data;
						}
						$tmp{$a} = $line;

					}					 
				}
			}			
			
		}
	}
					
	# Check to see if any options
	if ( $options ) {
		# Get rid of trailing ","
		$options = substr ( $options, 0, length ( $options ) - 1 );
		$tmp{'options'} = $options;
	}
	
	return ( $failure, $response, \%tmp );

}

sub ddclient_conf_parse_default {
	my $file = shift;
	
	if (!$file) {
		$file = $config{'conf2'};
	}
	
	my %result;
	read_file($file, \%result);
	
	return \%result; 
}

# This is substitute for the ddclient_conf_parse_multi that can handle multi US, HN
# Inputs: ($filename)
# Output: a hash containing global values and services definitions at key "services"
sub ddclient_conf_parse_multi {
	my $filename = shift;
	
	if (!$filename) {
		$filename = $config{'conf1'};
	}
	
	my %result;
	$result{'services'} = [];
	
	my $filecontent =  read_file_contents($filename);				 

	# Global definitions look like:
	# name=value [,name=value]*
	# Host definitions look like (actually that's a service definition):
	# [name=value [,name=value]*]* a.host.domain [,b.host.domain] [login] [password]	
	$filecontent =~ s/\\\n//g; # remove the \ continuations	
	
	# config options: 					   ((\S+=['"]?\S+['"]?)(\s*,\s*\S+=['"]?\S+['"]?\s*)*)
	# some space: 					 	   \s+   
	# the domain names, optionally 
	# prefixed by host=, can also be 
	# a number (must have one at least 1): (?:host=)?(($hostname_pattern(\s*,\s*(?:[-\w.]+\.\w+)|\d+)*)
	# optional username, password:         \s*(\S*)\s*(\S*)
	
	my $opt_pattern = '(?:(?:\'[^\']+\')|(?:"[^\"]+")|(?:\S+))';
	my $hostname_pattern = $PARSE_REGEXP{'hostname'};
	
	foreach my $line (split(/\n/, $filecontent)) {

		if ($line =~ m/^#/) {
			next;
		}
		elsif ($line =~ m/((\S+=$opt_pattern)(\s*,\s*\S+=$opt_pattern\s*)*)\s+(?:host=)?(($hostname_pattern)(\s*,\s*$hostname_pattern)*)(?:\s+((?:(\S+)\s+(\S+))|(\S+)))?$/) {
			my ($opts, $hostnames, $login, $password) = ($1, $4);
			
			if ($10) {
				$login = $10;
				$password = $11;				
			}
			elsif ($9) {
				$login = $10;
			}
			
			my %service;
			$service{'hostnames'} = [split(/\s*,\s*/, $hostnames)];
						
			foreach my $service_opt (split(/\s*,\s*/, $opts)) {
				my ($key, $value) = split(/\s*=\s*/, $service_opt);
				
				$service{$key} = $value;
			}
			
			if ($login) {
				$service{'login'} = $login;
				if ($password) {
					$service{'password'} = $password;
				}
			}
			
			push(@{$result{'services'}}, \%service); 
		}
		elsif ($line =~ m/^\s*((\S+=$opt_pattern)(\s*,\s*\S+=$opt_pattern\s*)*)\s*$/) {						
			my $cur;
			my $char;
			
			# The $cur related code is required because of ,'s occurring in the 
			# middle of quoted strings
			foreach my $val (split(/,/, $1)) {				
				# Is it a continuation of a not yet ended quoted string
				if ($cur) {
					# Not the end part
					if (index($val, $char) != length($val) - 1) {
						$cur .= ',' . $val;
						next;
					}
					else {
						# The end
						$val = $cur . $val;
					}
				}
				elsif ($val =~ /^\s*\S+=(['"])\S+[^'"]$/) {
					$char = $1;
					$cur = $val . ',';
					next;
				}
				
				my @keyval = split(/=/, $val);
				
				if (@keyval != 2) {
					last;
				}
				
				my $delim;
				if ($keyval[1] =~ /^\s*(["'])/) {
					$delim = $1;
				}
				$keyval[1] =~ s/^\s*$delim(.+)$delim\s*$/$1/;
				$keyval[0] =~ s/\s+//g;
								
				$result{$keyval[0]} = $keyval[1];
				
				$cur = undef;
			}
		}
		else {
			warn("Didn't match line: " . $line);
		}
			
	}
	
	return \%result;
}

# Inputs:	%current = environnment
# Outputs:	$check = 0 if no error, 1 otherwise
sub ddclient_check_protocol {

	my $check = 0;
	if ( $current{'server'} && $current{'login'} && $current{'password'} ) {
		$check = 1;
	}	
	return $check;
	
}

# Inputs:	%current = environnment
# Outputs:	$check = 0 if no error, 1 otherwise
sub ddclient_check_use {

	my $check = 0;
	if ( $current{$current{'use'}} ) {
		$check = 1;
	} else {
		if ( $current{'fw'} ) {
			$check = 1;
		}
	}
		
	return $check;
	
}

#
# Sets up configuration HTML for ddclient
#
sub ddclient_manual {

	# Initialize variables
	my $output 	= "";
	my $failure	= 0;
	my $message	= "";
	my $ref1;
	my $ref2;
	my $switch = 0;
	my $do_nothing = 0;
	my $default_tab = 'usage';
	
	# Get info from environment
	my $info = $current{'response'};	
	my $not_first = $current{'not_first'};	
	my $action = $current{'action'};
	my $cmd_line = $current{'cmd_line'};
	
	# Store output for user
	if ( $message ) { $info .= "<br>" . $message; }
	$message = "";
	
	# Scan through possible actions
	if ( $action =~ /^$text{'button_build'}/ ) {
		# Build command line from environment	
		( $message, $cmd_line ) = &ddclient_build_cmd_line();
		( $failure, $message ) = &ddclient_validate_cmd_line ( $cmd_line );
		$info .= "<br>" . $message;
	} elsif ( $action =~ /^$text{'button_test'}/ ) {
		( $failure, $message ) = &ddclient_validate_cmd_line ( $cmd_line );
		$info .= "<br>" . $message;
		if ( !$failure ) {
			# Adds -verbose -debug and -noexec options
			my $test_cmd = &ddclient_test_cmd_line ( $cmd_line );
			
			warn("testmode: $test_cmd");
			
			$message = &ddclient_manual_run( $test_cmd );
		}
	} elsif ( $action =~ /^$text{'button_run'}/ ) {
		( $failure, $message ) = &ddclient_validate_cmd_line ( $cmd_line );
		$info .= "<br>" . $message;
		if ( !$failure ) {
			# Adds -verbose -debug and -noexec options
			$message = &ddclient_manual_run( $cmd_line );
		}
	} elsif ( $action =~ /^$text{'button_protocol'}/ ) {
		# Change protocol
		$default_tab = 's_and_p';		
		$do_nothing++;
	} elsif ( $action =~ /^$text{'button_use'}/ ) {		
		# Change protocol
		$default_tab = 'routers';
		$do_nothing++;
	} elsif ( $action =~ /^$text{'button_save'}/ ) {
		# Look for a file /etc/webmin/ddclient/ddclient_cmd_line_params.info
		( $failure, $message ) = &ddclient_save_cmd_line( $cmd_line );
	} elsif ( $action =~ /^$text{'button_validate'}/ ) {
		( $failure, $message ) = &ddclient_validate_cmd_line ( $cmd_line );
	} elsif ( $action =~ /^$text{'button_previous'}/ ) {
		$message = &ddclient_prev_cmd_line();
		$not_first = 0;
	}  

	# Store output for user
	if ( $message ) { $info .= "<br>" . $message; }
	$message = "";

	# Check to see if first time
	if ( !$not_first ) {

		# Look for a file /etc/webmin/ddclient/ddclient_cmd_line_params.info
		( $failure, $message, $ref2 ) = &ddclient_read_config_file( $config{'cmd2'} );
		$info .= $message;

		# If this isn't found, pull defaults in from %config
		if ( $failure ) {
			$cmd_line = $config{'cmd1'};
		} else {
			@contents = @$ref2;
			$cmd_line = $contents[0];
		}

		# Parse command line into hash %current
		( $message, $ref1 ) = &ddclient_parse_cmd_line ( $cmd_line );	
		%current = %$ref1;

	}			
		
	# Store output for user
	if ( $message ) { $info .= "<br>" . $message; }

	# Set up tabs and headers
	@headings = ( $text{'heading_parameter'}, $text{'heading_value'}, $text{'heading_descr'} );	
	@tabs1 = ( 
			   [ 'usage', $text{'heading_usage'} ],
			   [ 'usage2', $text{'heading_usage2'} ],
			   [ 's_and_p', $text{'heading_servers_and_protocols'} ],
			   [ 'routers', $text{'heading_routers_and_ip_acquisition'} ]
			   );

 	# Basic Options
	# print &ui_hidden_table_start($text{'heading_manual_ops'}, "width=100%", 1, "basic", 1);
	print &ui_tabs_start(\@tabs1, 'tab_mode', $default_tab);

	# usage tab
	print &ui_tabs_start_tab('tab_mode', 'usage');
	print &ui_columns_start(\@headings);
	
	# Interate through loop of currently supported options
	foreach $key ( sort ( keys ( %valid_options ) ) ) {
		$value = $valid_options{$key};
		# Filter for basic options
		if ( $value =~ /^[1u]/ ) {
			&ddclient_manual_options_row ( $key, $value );
		}
	}

	print &ui_columns_end;
	print &ui_tabs_end_tab('tab_mode', 'usage');


	# Advanced usage tab
	print &ui_tabs_start_tab('tab_mode', 'usage2');
	print &ui_columns_start(\@headings);
	
	# Interate through loop of currently supported options
	foreach $key ( sort ( keys ( %valid_options ) ) ) {
		$value = $valid_options{$key};
		# Filter for basic options
		if ( $value =~ /^[4x]/ ) {
			&ddclient_manual_options_row ( $key, $value );
		}
	}

	print &ui_columns_end;
	print &ui_tabs_end_tab('tab_mode', 'usage2');


	# Servers and Protocols
	print &ui_tabs_start_tab('tab_mode', 's_and_p');
	print &ui_columns_start(\@headings);
	
	print "<tr><th>protocol</th><td>";
	&ddclient_protocol_dropdown();
	print "</td><td>$text{'config_protocol'}</td></tr>\n";
	print "<tr><td>&nbsp;</td>";
	print "<td><input type=submit name='action' value=$text{'button_protocol'}></td>\n";
	print "<td colspan=2>$text{'manual_protocol_button'}</td></tr>\n";

	# Get info from default protocol
	# i.e. 'dyndns2' 		=> "server=members.dyndns.org,login,password,mx,backupmx,wildcard,static,custom" ,
	my @options = split ( ",", $protocols{$current{'protocol'}});

	# Interate through loop of currently supported options
	foreach my $item ( @options ) {
		if ( $item =~ /\=/ ) {
			my ( $a, $b ) = split ( "=", $item );
			$item = $a;
			if ( !$current{$item} ) {
				$current{$item} = $b;
			}
		}
		$value = $valid_options{$item};
		if ( !($value =~ /^9/ ) ) {
			&ddclient_manual_options_row ( $item, $value );
		}
	}
	ddclient_manual_options_row ( 'host', $valid_options{'host'} );

	print &ui_columns_end;
	print &ui_tabs_end_tab('tab_mode', 's_and_p');


	# Routers tab
	print &ui_tabs_start_tab('tab_mode', 'routers');
	print &ui_columns_start(\@headings);
	
	print "<tr><th>use</th><td>";
	&ddclient_use_dropdown();
	print "</td><td>$text{'config_use'}</td></tr>\n";
	print "<tr><td>&nbsp;</td>";
	print "<td><input type=submit name='action' value='$text{'button_use'}'></td>\n";
	print "<td colspan=2>$text{'manual_use_button'}</td></tr>\n";

	# Get info from selected use option
	# i.e. 	'fw' => '6,fw,fw-skip,fw-login,fw-password'
	my $use = "";
	if ( $ddclient_nr{$current{'use'}} ) {
		$use = $current{'use'};
	} else {
		$use = "fw";
	}
	@options = split ( ",", $ddclient_nr{$use});

	# Interate through loop of currently supported options
	foreach my $item ( @options ) {
		$value = $valid_options{$item};
		&ddclient_manual_options_row ( $item, $value );
	}	

	print &ui_columns_end;
	print &ui_tabs_end_tab('tab_mode', 'routers');

	print &ui_tabs_end();
	# print &ui_hidden_table_end("basic");
	

	# Display current command line
	print &ui_table_start($text{'heading_cmd_line'}, "width=100%", 2);
	print '<tr><td width=40>1. <input type=submit name="action" value="' . $text{'button_build'} . '"></td>';
	print '<td>' . $text{'manual_build_button'} . '</td></tr>' . "\n"; 
	print "<tr><th align=left width=20%>" . $config{'exec1'} . "</th>";
	print "<td>" . &ui_textbox("cmd_line", $cmd_line, 80, 0, 1024) . "</td></tr>\n";
	print '<tr><td width=40>2. <input type=submit name="action" value="' . $text{'button_test'} . '"></td>';
	print '<td>' . $text{'manual_test_button'} . '</td></tr>' . "\n"; 
	print '<tr><td width=40>3. <input type=submit name="action" value="' . $text{'button_run'} . '"></td>';
	print '<td>' . $text{'manual_run_button'} . '</td></tr>' . "\n"; 
	print &ui_table_end();

	# System output
	print &ui_table_start($text{'heading_system_output'}, "width=100%", 1);
	if ( $info ) {
	
		print "<tr><td>" . &un_urlize ( $info ) . "</td></tr>";

	}
	print &ui_table_end();


	return $output;

}

#
# Sets up configuration HTML for ddclient
#
sub ddclient_config {
	my $daemon_config_ref = shift;

	# Initialize variables
	my $output 	= "";
	my $failure	= 0;
	my $message	= "";
	my ( $key, $value );
	my @output = ();
	my $out_ref;
			
	# Get info from environment
	my $info = $in{'response'};	
	my $action = $in{'action'};

	# Check actions
	if ( $action =~ /^$text{'button_update'}/ ) {
		# Update ddclient.conf & /etc/default/ddclient		
		( $failure, $message, $out_ref ) = &ddclient_conf_update();
		( $dfailure, $dmessage ) = &ddclient_update_daemon_file();
		if ($dmessage) {
			$message .= "<br/>" . $dmessage;
		}
	} elsif ( $action =~ /^$text{'button_previous'}/ ) {
		# Restore previous ddclient.conf
		( $failure, $message ) = &ddclient_prev_config();
	} elsif ( $action =~ /^$text{'button_add'}/ ) {
		# Add host definition to file
		( $failure, $message ) = &ddclient_add_host_definition();
	} elsif ( $action =~ /^$text{'button_del'}/ ) {
		# Remove host definition(s) from file
		( $failure, $message ) = &ddclient_del_host_definition();
	} elsif ( $action =~ /^$text{'button_daemon'}/ ) {
		# Remove host definition(s) from file
		( $failure, $message ) = &ddclient_update_daemon_file($daemon_config_ref);
	} elsif ( $action =~ /^$text{'button_validate'}/ ) {
		( $failure, $message, $out_ref ) = &ddclient_conf_update( "validate" );
	}

	if ( $message ) {
		$info .= "<br>" . $message;
	}

	# Set up tabs and headers
	@headings = ( $text{'heading_parameter'}, $text{'heading_value'}, $text{'heading_descr'} );	
	@tabs1 = ( 
			   [ 'daemon', $text{'heading_daemon'} ],
			   [ 'daemon2', $text{'heading_daemon2'} ],
			   [ 'd_run', $text{'heading_etc_default_options'} ]
			   );

 	# Basic Options
	# print &ui_table_start($text{'conf_title_options'}, "width=100%", 1, "basic");
	print &ui_tabs_start(\@tabs1, 'tab_mode', 'daemon');

	# Daemon tab
	print &ui_tabs_start_tab('tab_mode', 'daemon');
	print &ui_columns_start(\@headings);
	
	# Interate through loop of currently supported options
	foreach $key ( sort ( keys ( %valid_options ) ) ) {
		$value = $valid_options{$key};
		# Filter for basic options
		if ( $value =~ /^[1a]/ ) {
			&ddclient_manual_options_row ( $key, $value );
		}
	}

	print &ui_columns_end;
	print &ui_tabs_end_tab('tab_mode', 'daemon');


	# Advanced Daemon tab
	print &ui_tabs_start_tab('tab_mode', 'daemon2');
	print &ui_columns_start(\@headings);
	
	# Interate through loop of currently supported options
	foreach $key ( sort ( keys ( %valid_options ) ) ) {
		$value = $valid_options{$key};
		# Filter for basic options
		if ( $value =~ /^[4d]/ ) {
			&ddclient_manual_options_row ( $key, $value );
		}
	}

	print &ui_columns_end;
	print &ui_tabs_end_tab('tab_mode', 'daemon2');

	print &ui_columns_end;

	
	# /etc/default/ddclient options
	print &ui_tabs_start_tab('tab_mode', 'd_run');
	# Interate through loop of currently supported options
	print &ui_columns_start(\@headings);
	foreach $key ( sort ( keys ( %valid_options ) ) ) {
		$value = $valid_options{$key};
		# Filter for basic options
		if ( $value =~ /^[8]/ ) {
			&ddclient_manual_options_row ( $key, $value );
		}
	}
	print &ui_columns_end;
	print &ui_tabs_end_tab('tab_mode', 'd_run');

	print &ui_tabs_end();
	# print &ui_table_end("basic");
	
	if ( $info ) {

		print "\n<p><b>RESULT:</b><br><i>" . &un_urlize ( $info ) . "</i></p>";
	}

	return $out_ref;

}

#
# Inputs:	$cmd_line = current command line, %valid_options = module array
# Outputs:	$errors = errors found; %current = hash with parameters and values
#
sub ddclient_parse_cmd_line {

	# Initialize variables
	my $cmd_line = shift;
	my %tmp = {};
	my $error = "";
	my $message = "";
	my $valid = 1;
	my ( $a, $b, $tag );
	my $tmp_line = "";
	my $item;
	my @swap = ();
	my @options = ();
		
	if ( $cmd_line =~ /\"/ ) {
		# Switch " " to \x1A inside "quotes"
		my @swap = split ( "\"", $cmd_line );
		my $even = 0;
		foreach $item ( @swap ) {
			if ( length ( $item ) > 0 ) {
				if ( $even ) {
					$even = 0;
					$item =~ s/\s/\x1A/g;
					$item = '"' . $item . '"';
				} else {
					$even = 1;
				}
				$tmp_line .= $item;
			}
		}
		$cmd_line = $tmp_line;
	}	

	if ( $cmd_line =~ /\'/ ) {
		$tmp_line = "";
		# Switch " " to \x1A inside 'quotes'
		my @swap = split ( "\'", $cmd_line );
		my $even = 0;
		foreach $item ( @swap ) {
			if ( length ( $item ) > 0 ) {
				if ( $even ) {
					$even = 0;
					$item =~ s/\s/\x1A/g;
					$item = "'" . $item . "'";
				} else {
					$even = 1;
				}
				$tmp_line .= $item;
			}
		}
		$cmd_line = $tmp_line;
	}

	# Split up by spaces
	my @commands = split ( " ", $cmd_line );

	# Scan through items one by one
	foreach $item ( @commands ) {

		# Filter out blanks
		if ( $item ) {

			if ( $item =~ /^-/ ) {
				
				# Get rid of leading "-"
				$item = substr ( $item, 1 );
				
				# Switch \x1A back to space
				$item =~ s/\x1A/\s/g;
				
				# Check for "use="
				if ( $item =~ /^use/ ) {
					# If value is in %ddclient_nr, then assign to basic
					( $a, $b ) = split ( "=", $item );
					if ( $ddclient_nr{$b} ) {
						# Check to see if a basic= option is on line
						if ( $cmd_line =~ /$b\=/ ) {
							$tmp{$a} = $b;
						} else {
							$error .= "<br>" . $text{'error_missing_value'} . ": " . $b . "\n";
						}
					} else {
						# Check to see if a fw= option is on line
						if ( $cmd_line =~ /fw=/ ) {
							# Puts quotes around value if spaces
							if ( $b =~ /\s/ ) { $b = '"' . $b . '"'; }
							$tmp{$item} = $b;
						} else {
							$error .= "<br>" . $text{'error_missing_value'} . ": fw=\n";
						}
					}

				# Check for options
				} elsif ( $item =~ /^options/ ) {
					my @options = ();
					( $a, $b ) = split ( "=", $item );
					# Check for multiple options
					if ( $b =~ /,/ ) {
						@options = split ( ",", $b );
					} else {
						$options[0] = $b;
					}
					# Scan and assign options
					foreach $a ( @options ) {
						# Check to see if valid
						if ( $valid_options{$a} ) {
							$tmp{$a} = "yes";
						}
					}
				# Check for items with "="
				} elsif ( $item =~ /=/ ) {

					( $a, $b ) = split ( "=", $item );
					# Check to see if in valid options
					if ( $valid_options{$a} ) {
						# Validate item
						$valid = 1;
						( $valid, $message ) = &ddclient_validate ( $a, $b );
						if ( $valid ) {
							# Puts quotes around value if spaces
							if ( $b =~ /\s/ ) { $b = '"' . $b . '"'; }
							$tmp{$a} = $b;
						} else {
							$error .= "<br>" . $text{'error_invalid_option'} . ": $a=$b : " . $message;
						}
					} else {
						$error .= "<br>" . $text{'error_invalid_option'} . ": " . $a;
					}
					
				# Look for ones beginning with $text{'no'}
				} elsif ( $item =~ /^no\w+/ ) {

					# Split off rest of option
					$option = substr ( $item, 2 );
					# Check to see if in valid options
					if ( $valid_options{$option} ) {
						( $a, $type ) = split ( ",", $valid_options{$option} );
						$tmp{$option} = &ddclient_type ( $type, 0);
					} else {
						$error .= "<br>" . $text{'error_invalid_option'} . ": " . $item;
					}

				# Otherwise treat it as a $text{'yes'} option
				} else {
					# Check to see if in valid options
					if ( $type = $valid_options{$item} ) {
						$tmp{$item} = &ddclient_type ( $type, 1);
					} else {
						$error .= "<br>" . $text{'error_invalid_option'} . ": " . $item;
					}
				}

			} else {
				$error .= "<br>" . $text{'error_need_dash'} . ": " . $item;
			}

		}
	}
		
	return $error, \%tmp;

}

#
# Inputs:	%current = global array containing input; %valid_options
# Outputs:	$cmd_line
#
sub ddclient_build_cmd_line {
	
	# Initialize variables
	my $cmd_line = "";
	my $item = "";
	my $error = "";
	my $do_nothing = 0;
	
	# Scan through list of valid options and match against %in
	while ( ( $key, $value ) = each ( %current ) ) {

		# Check to see if any value is set
		if ( length ( $value ) > 0 ) {
			# Check for "use"
			if ( $key =~ /^use/ ) {
				# Check to see if value="none"
				if ( !($value =~ /^none$/) ) {
					$cmd_line .= "-use=$value ";
				}
			# Filter out any of if | ip | fw | cmd | web
			} elsif ( $ddclient_nr{$value} ) {

				# Do nothing
				$do_nothing++;

			# Check for "help"
			} elsif ( $key =~ /^help$/ ) {
				# Scan for $text{'no'} values
				if ( $value =~ /^yes$/ ) {
					$cmd_line .= "-help ";
				} else {
					$cmd_line =~ s/\-help\s//;
				}
								
			} else {
				# Scan for $text{'no'} values
				if ( $value =~ /^$text{'no'}$/ ) {
					# Do nothing
					$do_nothing++;
				} else {
					$item = $key;
					# Check against %valid_options
					my $type = $valid_options{$key};
					if ( $type ) {
						# Check for protocol options
						if ( ! ($type =~ /^9/ )) {
							if ( $type =~ /yesno$/ ) {
								$cmd_line .= "-" . $item . " ";
							} else {
								$cmd_line .= "-" . $item . "=" . ($value ? $value : "\'\'") . " ";
							}
						}
					}
				}
			}
		}
	}
		
	return ( $error, $cmd_line );
}

# Returns the currently defined services and the status of their hosts
# Format returned: 
# { host1=>items of host1, host2=>items of host2 }
# {cache_ip=>ip, dns_ip=>ip, lastupdate=>time, lastmtime=>time, status=>stat}
# Some info is read from the cache file

use Socket;
sub ddclient_service_status_all() {
	my ($cache_filename, $definitions) = @_;
	
	my %result;
	my @service_result;
	
	my ($cache_ref, $last_run) = _ddclient_read_cache($cache_filename);		
	my %cache = %{$cache_ref};
	
	# Combine everything into the above mentioned data structure and do some
	# dns lookups
	my $number = 0;
	foreach my $service (@{$definitions->{'services'}}) {		
		foreach my $host (@{$service->{'hostnames'}}) {			
			warn "Doing" . $host;
			
			if (exists($cache{$host})) {
				$result{$host} = $cache{$host}  		
			}
			else {
				$result{$host} = {'cache_ip'=>'', 'status'=>'unknown', 
					'lastatime'=>'', 'lastmtime'=>''};
			}
			
			my $packed_ip = gethostbyname($host);
    		$result{$host}->{'dns_ip'} = defined $packed_ip ? inet_ntoa($packed_ip) : 'failed';
    		
    		warn $host . $result{$host}->{'dns_ip'};
		}
		
		push @service_result, {'configured_ip'=>'none'};
	}
	
	return ([@service_result], \%result, $last_run);
}

# Helper func
sub _ddclient_read_cache($) {
	# Read the cache file into a var
	my $filecontent =  read_file_contents(shift);
		
	# Capture info from each line (refactored from index.cgi)
	my %cache;
	my $last_run;	
	
	foreach my $line (split(/\n/, $filecontent)) {
		if ( $line =~ /last updated.+\((\d+)\)/ ) {
			warn("neverland $1");
			$last_run = $1;
		}
		else {		
			$begin = index ( $line, "host=" ) + 5;
			$end = index ( $line, ",", $begin );
			$a = substr ( $line, $begin, $end - $begin );
	
			$begin2 = index ( $line, "ip=" ) + 3;
			$end2 = index ( $line, ",", $begin2 );
			$ip = substr ( $line, $begin2, $end2 - $begin2 );
	
			$begin3 = index ( $line, "atime=" ) + 6;
			$end3 = index ( $line, ",", $begin3 );
			$aa = substr ( $line, $begin3, $end3 - $begin3 );
			
			$begin_status = index ( $line, "status=" ) + 7;
			$end_status = index ($line, ",", $begin_status);
			$status = substr( $line, $begin_status, $end_status - $begin_status);
			
			$begin_mtime = index ( $line, "mtime=" ) + 6;
			$end_mtime = index ( $line, ",", $begin_mtime);
			$mtime = substr( $line, $begin_mtime, $end_mtime - $begin_mtime);
			
			warn("mtime: $mtime :: $line");
			$mtime = $mtime > 1000 ? scalar localtime($mtime) : undef; # 
	
			if ( !($a =~ /^if$/) && ($a =~ /\w+\.\w+/) ) {
				$cache{$a} = {'cache_ip'=>$ip, 'mtime'=>$mtime,
					'atime'=>scalar localtime($aa), 'status'=>$status};
			}
		}
	}
	
	return (\%cache, $last_run);	
}

sub _ddclient_error_strip_help {
	my $input = shift;
	
	return substr($input, 0, index($input, "usage:"));
}

# Input: hash with options for a single run of ddclient in order 
# to capture the ip
# Output: the ip as obtained by ddclient with the given settings
use File::Temp qw/:mktemp/;
sub ddclient_query_ip {
	my $opts = shift;
	my %options = %{$opts};
	
	# Need an empty file, but can't use /dev/null as ddclient 'fixes' the permissions
	my ($fh, $file) = mkstemp("/tmp/webmin_ddclient_runXXXXX");
	close $fh;	
	
	$options{'file'} = $file;
	$options{'debug'} = "yes";
	
	my %oldcurrent = %current;
	
	%current = %options;
	my $cmdline = ddclient_build_cmd_line($options);
	
	my $output = backquote_command("$config{'exec1'} $cmdline 2>&1"); 
	unlink($file);
	%current = %oldcurrent;
	
	if ($output =~ m/reports (<undefined>|[\d.]+)/ && $1 ne "<undefined>") {
		return("success", $1);
	}
	
	# Else we have an error which is printed on the first line		
	return("failure", _ddclient_error_strip_help($output));
}

sub ddclient_query_ip_default {
	my $config = shift;
		
	return ddclient_query_ip;
}

sub ddclient_deserialize_hash {
	my $output = shift;
	my %result;
	
	$output = un_urlize($output);
	foreach my $item (split(/,/, $output)) {
		my ($key, $value) = split(/=/, $item);
		
		$result{$key} = $value;
	}	
	
	return \%result;
}

# Gives those elements for which holds x in A and x !in B
# Could make this somewhat more efficient by first sorting and then merging
sub _build_exclude($$) {
	my ($all_ref, $excl_ref) = @_;
	
	my @all_keys = @{$all_ref};
	my @excl_keys = @{$excl_ref};
	my @result;
	
	foreach my $key (@all_keys) {
		my $matched = 0;

		foreach my $excl (@excl_keys) {
			if ($key eq $excl) {
				$matched = 1;
				last;					
			}
		}
			
		if (!$matched) {
			push @result, $key;
		}
	}
	
	return @result;
}

# Extendend version of the _ddclient_build_hash function with more parameters
sub _ddclient_build_hash_extended {
	my $hash_ref = shift;
	my $separator = shift;
	my $do_escape = shift;
	my $exclude = shift;
	my @keys = @_;
	my %hash = %{$hash_ref};
	
	if ($exclude) {
		@keys = _build_exclude([keys %hash], [@keys]);
	}
		
	my $output;
	foreach my $key (sort @keys) {
		if (!$hash{$key}) {
			next;
		}
		
		my $must_escape = $do_escape && $hash{$key} =~ m/\s/;		
		
		if ($output) {
			$output .= $separator;
		}
				
		$output .= "$key=";
		$output .= "\"" if $must_escape;
		$output .= $hash{$key};		
		$output .= "\"" if $must_escape;
	}
	
	return $output;
}

# A little wrapper around _ddclient_build_hash_extended
sub _ddclient_build_hash {
	my $hash_ref = shift;
	my $separator = shift;
	
	return _ddclient_build_hash_extended($hash_ref,
		$separator,	undef, 1, @_);
}

sub ddclient_serialize_hash {
	my $hash_ref = shift;
	my %serialize = %{$hash_ref};
	
	my $output;
	foreach $key (keys %serialize) {
		$output = $output ? $output . "," : ""; 				
		$output .= "$key=$serialize{$key}"; 
	} 	
	
	return urlize($output);
}

sub ddclient_config_add_service {
	my ($service_ref, @hostnames) = @_;
	
	my $config = ddclient_conf_parse_multi("/etc/ddclient.conf");	
	$service_ref->{'hostnames'} = \@hostnames; 	
	push @{$config->{'services'}}, $service_ref;
	
	ddclient_config_save_multi($config);
	
	webmin_log("create", "service", ddclient_service_description($service_ref), $service_ref);
}

# This method doesn't check the validity of the given config, it just serializes it.
sub ddclient_config_save_multi {	
	my $config_ref = shift;
	my $filename = shift;
	
	my %filtered = %{$config_ref};
	
	# remove the /etc/default/ddclient options
	my @def_options = grep { $valid_options{$_} =~ /^8/ } keys %{$config_ref};
	
	# These options are related to use= and will be grouped, see #12
	my @use_options = grep { $valid_options{$_} =~ /^3/ } keys %{$config_ref};
		
	my $output .= "# Written by webmin ddclient\n# " . `date`;	
	
	$output .= "\n# Daemon and run-time options\n";	
	$output .= _ddclient_build_hash_extended(\%filtered, "\n", 1, 1,
		'services', 'use', @def_options, @use_options);
		
	$output .= "\n\n# IP Address Acquisition\n";
	# write the use= first
	$output .= _ddclient_build_hash_extended(\%filtered, "\n", 1, 0, 'use');
	$output .= "\n";
	$output .= _ddclient_build_hash_extended(\%filtered, "\n", 1, 0, @use_options);
	
	$output .= "\n\n# Updating Service Configuration\n";
	
	foreach my $service (@{$filtered{'services'}}) {
		$output .= _ddclient_build_hash($service, ", \\\n  ", 'hostnames');
		
		# Don't ever add invalid hostnames, cause we can't read them
		my @valid_hostnames = grep { ddclient_hostname_validate($_) } @{$service->{'hostnames'}};
		if (!@valid_hostnames) {
			@valid_hostnames = ('invalidhostname.lan');
		}		
		$output .= " " . join(", ", @valid_hostnames);
		$output .= "\n\n"; 
	}
	
	if (!$filename) {
		$filename = $config{'conf1'};
	}	
				
	lock_file($filename);
	
	# Backup config if not a tmp config
	if ($filename !~ /^\/tmp/) {
		ddclient_config_backup($filename);
	}
	
	open CONFIG, ">" .$filename;
	print CONFIG $output;
	close CONFIG;
	
	unlock_file($filename);	
}

sub ddclient_update_ip_strategy {
	my ($config, $use, $options_ref) = @_;
	
	my $failure = 0;
	
	# Check to see if Non Router
	if ( $ddclient_nr{$use} ) {

		# Split out options for this IP acquisition method
		if ( $ddclient_nr{$use} =~ /,/ ) {
			@data = split ( ",", $ddclient_nr{$use} )
		} else {
			$data[0] = $ddclient_nr{$use};
		}


	} else {
		$use = "fw";
		@data = split ( ",", $ddclient_nr{$use} )
	}
	
	$config->{'use'} = $use;

	foreach my $which ( @data ) {

		if ( $options_ref->{$which} ) {
			( $valid, $message ) = &ddclient_validate ( $which, $options_ref->{$which} );
			if ( $valid ) {
				$config->{$which} = $options_ref->{$which};
			} else {
				$failure++;
				$response .= "<br>" . "$which=" . $options_ref->{$which} . " " . $message;
			}
		} else {
			$failure++;
			$response .= "<br>" . "use=" . $which . " " . $text{'error_missing_value_for'} . " " . $which;
		}
	}
	
	my @allopts;
	
	# Create an array of all IP acq related options
	map { push @allopts, split(",", $ddclient_nr{$_}) } keys %ddclient_nr;
	
	# Options to remove: { x | x el @allopts  AND !x el @data }		
	my @cleanup = _build_exclude(\@allopts, ['use', 'services', @data]);
	
	foreach my $opt (@cleanup) {
		delete $config->{$opt};
	}
	
	return ($failure, $response);
}

sub update_service_protocol {
	my ($service_ref, $vals_ref) = @_; 
	
	# Split off parameters supported by this protocol
	# i.e. 'dyndns2' => "server=members.dyndns.org,login,password,mx,backupmx,wildcard,static,custom,host" 
	@data = split ( ",", $protocols{$service_ref->{'protocol'}} );
	$found = 1;
	foreach $item ( @data ) {
		# Get rid of "=" if it exists
		if ( $item =~ /\=/ ) {
			my ( $a, $b ) = split ( "=", $item );
			$item = $a;
		}
		if ( $vals_ref->{$item} ) {
			$service_ref->{$item} = $vals_ref->{$item};
		}
		# Check to see if on required list
		if ( index ( $required, $item ) > 0 ) {
			$found++;
		}
	}
	
	webmin_log("modify", "service", ddclient_service_description($service_ref));
}

# Creates a textual description of a service
sub ddclient_service_description($) {
	my $service = shift;
	
	return $service->{'server'} . ' (' . $service->{'login'} . ')';
}

sub ddclient_hostname_force_update_convert {
	my $config_file = shift;
	
	my $output = ddclient_hostname_force_update($config_file, @_);
	if (!$output) {
		$output = '<no output was produced>';
	}
	else {
		$output = html_escape($output);
		$output =~ s!\n!<br/>!g;
	}
	
	return $output;
}

sub ddclient_hostname_force_update {
	my $config_file = shift;
	
	if (!$config_file) {
		$config_file = $config{'conf1'};
	}
	
	my $hostnames = join(",", @_);
	
	warn("jow: " . "$config{'exec1'} -file=$config_file -host=$hostnames -debug -force -nosyslog -noquiet");
	
	my $output = backquote_logged("$config{'exec1'} -file=$config_file -host=$hostnames -debug -force -nosyslog -noquiet");
	
	warn("the output: $output");
	
	webmin_log("refresh", "hostname", $hostnames, {'output'=>$output});
	
	if ($output =~ m/(SUCCESS.+)/g) {
		return $1;
	}

	return $output;
}

sub ddclient_hostname_validate {
	my $hostname = shift;
	my $hostname_pattern = $PARSE_REGEXP{'hostname'};
	
	return $hostname =~ m/$hostname_pattern/;
}

sub render_instructions() {
	my $i = 1;
	my $output = "$text{'us_instr'}<ol>";
	while(my $text = $text{'us_instr_' . $i++}) {		
		$output .= "<li>$text</li>";
	}
	$output .= "</ol>";	
	$output .= "$text{'us_instr_end'}";
	
	return $output;
}

sub render_provider_links() {
	my $i = 1;
	my $output = "$text{'us_provider'}<ul>";
	while (my $link = $text{'us_provider_' . $i . '_link'}) {
		my $title = $text{'us_provider_' . $i . '_title'};
		$output .= '<li><a href="http://' . $link . '" target="_blank">' . $title  . '</a></li>';
		$i++;
	}
	$output .= "</ul>";
	
	return $output;
}

# A debugging function, can be removed once debugging is over
sub print_r {
    package print_r;
    our $level;
    our @level_index;
    if ( ! defined $level ) { $level = 0 };
    if ( !@level_index ) { $level_index[$level] = 0 };

    for ( @_ ) {
        my $element = $_;
        my $index   = $level_index[$level];

        print "\t" x $level . "[$index] => ";

        if ( ref($element) eq 'ARRAY' ) {
            my $array = $_;

            $level_index[++$level] = 0;

            print "(Array)\n";

            for ( @$array ) {
                main::print_r( $_ );
            }
            --$level if ( $level > 0 );
        } elsif ( ref($element) eq 'HASH' ) {
            my $hash = $_;

            print "(Hash)\n";

            ++$level;

            for ( keys %$hash ) {
                $level_index[$level] = $_;
                main::print_r( $$hash{$_} );
            }
        } else {
            print "$element\n";
        }

        $level_index[$level]++;
    }
} # End print_r

BEGIN {
	$DEBUG = 1;
	if ($DEBUG) {
	  use warnings;
	  use CGI::Carp qw(carpout); 
      open(ERROR_LOG, ">>/tmp/webmin_ddclient_error_log") 
                      or die("Can't setup error log: $!\n");
      carpout(\*ERROR_LOG);
	}
}
