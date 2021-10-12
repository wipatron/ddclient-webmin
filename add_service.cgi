#!/usr/bin/perl
#
# Author:	D. Bierer <doug@unlikelysource.com>
#			B. Schlarmann <bschlarmann@odesk.com>
# Date:		20 March 2009
# Notes:	None
#

require './ddclient-lib.pl';

my @headings =
  ( $text{'heading_parameter'}, $text{'heading_value'},
	$text{'heading_descr'} );

my %steps;
my %steps_ip_acq = (
	'select_ip_acq' => {
		'next'          => 'configure_ip_acq',
		'render_method' => render_select_ip_acq,
		'apply_method'  => apply_select_ip_acq
	},
	'configure_ip_acq' => {
		'next'          => 'check_ip_acq',
		'prev'          => 'select_ip_acq',
		'render_method' => render_configure_ip_acq,
		'apply_method'  => apply_configure_ip_acq
	},
	'check_ip_acq' => {
		'next'          => 'save_ip_acq',
		'prev'          => 'configure_ip_acq',
		'render_method' => render_check_ip_acq
	},
	'save_ip_acq' => {
		'next'			=> 'finish',
		'prev'			=> 'configure_ip_acq',
		'render_method' => render_save_ip_acq,
		'apply_method'  => apply_save_ip_acq,
	},
	'finish' => {
		'render_method' => render_finish	
	}
);
	
my %steps_service = (
    # The semantics of the pre_step are different from the rest
    # First the apply_method is called if it returns something then render_method is called
    # without the buttons
	'pre_step' => {
		'render_method' => 'render_protocol_pre',
		'apply_method' => 'apply_protocol_pre'
	},
	'instr_protocol' => {
		'next'			=> 'select_protocol',
		'render_method' => render_instr_protocol
	},
	'select_protocol' => {
		'prev'			=> 'instr_protocol',
		'next'			=> 'configure_protocol',
		'render_method' => render_select_protocol,
		'apply_method'  => apply_select_protocol
	},
	'configure_protocol' => {
		'next'			=> 'set_host',
		'prev'			=> 'select_protocol',
		'render_method' => render_configure_protocol,
		'apply_method'  => apply_configure_protocol
	},
	'set_host' => {
		'next'			=> 'save_service',
		'prev'          => 'configure_protocol',
		'render_method' => render_set_host,
		'apply_method'  => apply_set_host,
		'exclude_edit'  => 1
	},
	'save_service' => {
		'next'          => 'finish',
		'prev'			=> 'set_host',
		'render_method' => render_save_service,
		'apply_method'  => apply_save_service
	},
	'finish' => {
		'render_method' => render_finish
	}
);

my %start_steps = (
	'ip_acq'=>'select_ip_acq',
	'service'=>'instr_protocol'
);

# Init the ddclient library
ddclient_select_options();

ReadParse();

if ( defined( $in{'current_config'} ) ) {
	%current = %{ ddclient_deserialize_hash( $in{'current_config'} ) };
}

my $type = $in{'type'} || 'service';

%steps = $type eq 'ip_acq' ? %steps_ip_acq : %steps_service;
my $image = $type eq 'ip_acq' ? 'ip_acq.png' : 'hostnames_add.png';

my ( $old_step, $new_step ) = get_steps();

my $apply_fault;
my $do_pre;
# Was this a forward step then call the apply functions
if ($old_step && defined($steps{$old_step}->{'apply_method'})) {
	$apply_fault = $steps{$old_step}->{'apply_method'}();
	
	if ($apply_fault) {
		$new_step = $old_step;
	}
}
elsif (!$new_step) {
	$new_step = $start_steps{$type};
	
	$do_pre = 1;
}

my $progress = $do_pre ? $text{'add_service_warning'} : 
	$text{'add_service_progress'} . get_progress(\%steps, $new_step, $start_steps{$type});

# Now the template itself
ui_print_header(
	$progress,
	$text{'add_service_' . $type},
	undef,
	undef,
	0,
	0,
	&help_search_link( "ddclient", "man", "doc", "google" ),
	undef, undef, undef
);

if ($do_pre && exists($steps{'pre_step'}) && $steps{'pre_step'}->{'apply_method'}()) {
	my $cont_link = "add_service.cgi?step=$new_step&type=$type&current_config=" . 
		ddclient_serialize_hash(\%current, ",");
	$steps{'pre_step'}->{'render_method'}($cont_link);
}
else {
	print '<br/><br/>';
	
	print '<div style="height: 80px;"><div style="float: left"><img src="images/' . $image . '"/></div>' . 
			'<div style="margin-left: 85px;">' . text('add_service_' . $new_step) . '</div></div>';
	
	print '<hr/>';
	
	print '<div style="padding-left: 80px; padding-right: 80px;">';
	print ui_form_start( 'add_service.cgi', 'POST' );
	print ui_hidden( 'current_config', ddclient_serialize_hash(\%current, ",") );
	print ui_hidden( 'step', $new_step );
	print ui_hidden( 'type', $type );
	
	$steps{$new_step}->{'render_method'}($apply_fault);
	print '</div>';
	
	print '<hr/>';
	
	print '<div style="padding-left: 80px;">';
	
	foreach my $button ( ('prev', 'next' ) ) {
		my $def = $steps{$new_step}->{$button};
	
		if ($steps{$def}->{'exclude_edit'} && $current{'is_edit'}) {
			$def = $steps{$def}->{$button};
		}
		
		if ($def) {
			push @buttons, [ $button . '_' . $def, $text{ 'add_service_' . $button } ];		
		}	
	}
	
	print ui_form_end( \@buttons, "width=50%" );
	
	print '</div>';
}

ui_print_footer( "./index.cgi", $text{'return'}, 'show_services.cgi', $text{'display_services'} );

# The render functions
sub render_select_ip_acq() {
	# Copied over from ddclient-lib.pl
	print ui_columns_start( \@headings );

	print "<tr><th>use</th><td>";
	ddclient_use_dropdown();
	print "</td><td>$text{'config_use'}</td></tr>\n";

	print ui_columns_end();
}

sub render_configure_ip_acq() {	
	# Copied over from ddclient-lib.pl
	print ui_columns_start( \@headings );

	# Get info from selected use option
	# i.e. 	'fw' => '6,fw,fw-skip,fw-login,fw-password'
	my $use = "";
	if ( $ddclient_nr{ $current{'use'} } ) {
		$use = $current{'use'};
	}
	else {
		$use = "fw";
	}
	@options = split( ",", $ddclient_nr{$use} );

	# Interate through loop of currently supported options
	foreach my $item (@options) {
		$value = $valid_options{$item};
		ddclient_manual_options_row( $item, $value );
	}

	print ui_columns_end();
}

sub render_check_ip_acq() {
	my ( $result, $ip ) = ddclient_query_ip( \%current );
	if ( $result eq "failure" ) {
		print $text{'add_service_check_ip_acq_failure'} . ": " . $ip;
	}
	else {
		print $text{'add_service_check_ip_acq_success'} . ": $ip";
	}

	return ( "configure_ip_acq", "select_protocol" );
}

sub render_select_protocol() {	
	print ui_columns_start( \@headings );
	
	print "<tr><th>protocol</th><td>";
	ddclient_protocol_dropdown();
	print "</td><td>$text{'config_protocol'}</td></tr>\n";
	
	print ui_columns_end();
}

sub render_configure_protocol() {	
	print ui_columns_start( \@headings );
	
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
			ddclient_manual_options_row ( $item, $value );
		}
	}
	
	print ui_columns_end();
}

sub render_set_host {
	my $fault = shift;
		
	if ($fault) {
		print text('add_service_set_host_error') . "<br/><br/>";
	}
		
	print text('add_service_set_host_desc') . ":<br/>";	
	
	print ui_textbox('hostname', $current{'hostname'} || $in{'hostname'}, 30);
}

sub render_finish() {
	print '<a href="show_services.cgi">' . $text{'add_service_finish_continue'} . '</a>';
}

sub render_save_service() {
	my ($fh, $file) = mkstemp("/tmp/webmin_ddclient_forceXXXXX");
	close $fh;
	
	my $config = ddclient_conf_parse_multi();
	
	# Backup the current config, because we're going to process it
	my %current_copy = %current;
	
	# Refactor XXX
	delete $current_copy{'is_edit'};
	delete $current_copy{'hostname'};
	delete $current_copy{'service_definition'};
	
	if ($current{'is_edit'}) {
		$current_copy{'hostnames'} = $config->{'services'}->[$current{'service_definition'}]->{'hostnames'};
	}
	else {
		$current_copy{'hostnames'} = [$current{'hostname'}];
	}
	
	$config->{'services'} = [\%current_copy];
		
	ddclient_config_save_multi($config, $file);	
	my $output = ddclient_hostname_force_update_convert($file, @{$current_copy{'hostnames'}});
	unlink($file);
	
	print $text{'add_service_check_output'} . "<br/><br/>";
	print '<div style="border: thin dashed black">' . $output . '</div>';
		
	print "<br/>";
		
	print ui_columns_start( [$text{'setting'}, $text{'value'}] );
	
	foreach my $val ( ('protocol', 'login', 'hostname', 'server' )) {
		if ($current{$val}) {
			print ui_columns_row([text('add_service_config_us_' . $val), $current{$val}], []);
		}
	}
	
	print ui_columns_end();
}

sub render_save_ip_acq() {
	print ui_columns_start( [$text{'setting'}, $text{'value'}] );
	
	foreach my $val ( ('use', 'ip', 'if', 'fw', 'login', 'cmd' )) {
		if ($current{$val}) {
			print ui_columns_row([text('add_service_config_ip_' . $val), $current{$val}], []);
		}
	}
	
	print ui_columns_end();	
}

sub render_instr_protocol() {
	print render_instructions();
	print "<br/><br/>";
	print render_provider_links();
}

sub render_protocol_pre() {
	my $cont_link = shift;
	my $ip_acq_link = 'do_services.cgi?action=edit_ip_acq';
	
	print <<CSS;
<style type="text/css">
img {
	vertical-align: middle;	
}
</style>
CSS
	
	print '<br/><div style="width: 100%"><div style="width: 70%; margin-left: auto; margin-right: auto;"><img style="float: left; margin-right: 10px; padding-bottom: 25px;" src="images/warning.png"/>';
	print $text{'add_service_protocol_pre_msg1'};
	
	print '<br/><br/>';
	print $text{'add_service_protocol_pre_msg2'};
	print '<br/><br/>';
		
	print '<a href="' . $ip_acq_link . '">' . $text{'add_service_protocol_pre_ip_acq'} . '</a> | ';			
	print '<a href="' . $cont_link . '">' . $text{'add_service_protocol_pre_cont'} . '</a>';
	
	print '</div></div>';
	
					
	
}

## Apply methods
sub apply_select_ip_acq() {
	# Clean up if different use
	if ($current{'use'} ne $in{'use'}) {		
		foreach my $item (split( ",", $ddclient_nr{$current{'use'}})) {
			warn $current{$item};
			delete $current{$item};
			warn $current{$item};
		}
	}
	
	$current{'use'} = $in{'use'};
	
	return 0;
}

sub apply_configure_ip_acq () {
	my $item = $current{'use'};

	# Check to see if Non Router
	if ( $ddclient_nr{$item} ) {

		# Split out options for this IP acquisition method
		if ( $ddclient_nr{$item} =~ /,/ ) {
			@data = split( ",", $ddclient_nr{$item} );
		}
		else {
			$data[0] = $ddclient_nr{$item};
		}

	}
	else {
		$item = "fw";
		@data = split( ",", $ddclient_nr{$item} );
	}

	foreach my $which (@data) {
		
		if ( defined($in{$which}) ) {
			( $valid, $message ) =
			  &ddclient_validate( $which, $in{$which} );
			if ($valid) {
				$current{$which} = $in{$which};
			}
			else {
				$failure++;
				$response .=
				  "<br>" . "$which=" . $in{$which} . " " . $message;
			}
		}
		else {
			$failure++;
			$response .=
			    "<br>" . "use=" 
			  . $which . " "
			  . $text{'error_missing_value_for'} . " "
			  . $which;
		}
	}
	
	return $failure;
}

sub apply_select_protocol() {
	# Clean up if different protocol
	if ($current{'protocol'} ne $in{'protocol'}) {
		foreach my $item (split ( ",", $protocols{$current{'protocol'}} )) {
			my ($val_item, $val_default) = split(/=/, $item);
			
			delete $current{$val_item};
		}
		delete $current{'server'};
		
		foreach my $item (split (",", $protocols{$in{'protocol'}})) {
			my ($val_item, $val_default) = split(/=/, $item);
			$current{$val_item} = $val_default;
		}
	}
	$current{'protocol'} = $in{'protocol'};
	
	return 0;
}

sub apply_configure_protocol() {
	update_service_protocol(\%current, \%in);
	
	return 0;
}

sub apply_set_host() {
	if (!ddclient_hostname_validate($in{'hostname'})) {
		return 1;
	}
	
	$current{'hostname'} = $in{'hostname'};
	
	return 0;
}

sub apply_save_service() {		
	if ($current{'is_edit'}) {
		warn("getting edit");
		
		my $config = ddclient_conf_parse_multi();
		my $hostnames = $config->{'services'}->[$current{'service_definition'}]->{'hostnames'};
				
		$current{'hostnames'} = $hostnames;		
		$config->{'services'}->[$current{'service_definition'}] = \%current;
		
		# Refactor XXX
		delete $current{'service_definition'};
		delete $current{'is_edit'};
		
		ddclient_config_save_multi($config);
		
		webmin_log("modify", "service", 
			ddclient_service_description(\%current));
	}
	else {
		my $hostname = $current{'hostname'};
		$current{'hostname'} = undef;
			
		ddclient_config_add_service(\%current, $hostname);
	}
	
	return 0;	
}

sub apply_save_ip_acq() {	
	my $config = ddclient_conf_parse_multi();
	my $old_use = $config->{'use'};
	
	ddclient_update_ip_strategy($config, $current{'use'}, \%current);
	
	ddclient_config_save_multi($config);
	
	webmin_log("modify", "ip_acq", "", {'old_use'=>$old_use, 'new_use'=>$current{'use'}});
	
	return 0;
}

sub apply_protocol_pre() {
	$config = ddclient_conf_parse_multi();
	my ($ip_stat, $ip_used) = ddclient_query_ip($config);
	
	if ($ip_stat ne 'success') {
		return 1;
	}
	
	return;
}

sub get_steps() {
	my $old_step;
	my $step;
	if ( !defined( $in{'step'} ) ) {
		return;
	}

	foreach my $key ( keys %steps ) {		
		if ( defined( $in{ 'next_' . $key } ) ) {			
			$step     = $key;
			$old_step = $in{'step'};
			last;
		}
		elsif ( defined( $in{ 'prev_' . $key } ) ) {
			$step = $key;
			last;
		}
	}
	
	if (!$step && $in{'step'}) {
		return ( undef, $in{'step'} );
	}
	else {
		return ( $old_step, $step );		
	}	
}

sub get_progress {
	my $steps_ref = shift;
	my $current_step = shift;
	my $start = shift;
	
	my $i = 1;
	while ($current_step ne $start) {
		$start = $steps_ref->{$start}->{'next'};
		$i++;
	}
	
	my @length = keys %{$steps_ref};
	return "$i / " . @length;
}