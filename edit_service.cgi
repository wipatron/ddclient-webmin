#!/usr/bin/perl
#
# Author:	D. Bierer <doug@unlikelysource.com>
#			B. Schlarmann <bschlarmann@odesk.com>
# Date:		23 March 2009
# Notes:	None
#

require './ddclient-lib.pl';

my @headings =
  ( $text{'heading_parameter'}, $text{'heading_value'},
	$text{'heading_descr'} );

# Init the ddclient library
ddclient_select_options();

ui_print_header(
	$text{'edit_service'},
	'',
	"config",
	"config",
	undef,
	0,
	1,
	&help_search_link( "ddclient", "man", "doc", "google" ),
	undef, undef, undef
);
ReadParse();

my $service_definition_no = $in{'service_definition'};

my $config = ddclient_conf_parse_multi();

if ($in{'submit'}) {
	update_service_protocol($config->{'services'}->[$service_definition_no], \%in);
	ddclient_config_save_multi($config);
	
	print $text{'edit_service_saved'};
}

# Needed for ddclient_manual_options_row as it used global vars
%current = %{$config->{'services'}->[$service_definition_no]};

print ui_columns_start( \@headings );
print ui_form_start( 'edit_service.cgi', 'POST' );
print ui_hidden('service_definition', $service_definition_no);

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
	
	ddclient_manual_options_row ( $item, $value );
}

print ui_form_end([['submit', $text{'conf_save'}]]);
print ui_columns_end();

ui_print_footer("./show_services.cgi",$text{'show_services_title'});