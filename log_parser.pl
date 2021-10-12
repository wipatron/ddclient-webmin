# log_parser.pl
# Functions for parsing this module's logs

do "../ui-lib.pl";
do "../web-lib.pl";
init_config();
# parse_webmin_log(user, script, action, type, object, &params)
# Converts logged information from this module into human-readable form
sub parse_webmin_log
{
		
my ($user, $script, $action, $type, $object, $p) = @_;
$object = &html_escape($object);

my $text_use = 'log_' . ($text{'log_' . $action . '_' . $type} ? $action . '_' . $type : $action); 

if ($action eq 'modify') {	
	return &text($text_use, "<tt>$object</tt>");
	}
elsif ($action eq 'create') {
	return &text($text_use, "<tt>$object</tt>");
	}
elsif ($action eq 'delete') {
	return &text($text_use, "<tt>$object</tt>");
	}
elsif ($action eq 'refresh') {
	return &text($text_use, "<tt>$object</tt>");
	}
elsif ($action eq 'apply') {
	return $text{'log_apply'};
	}
elsif ($action eq 'start') {
	return $text{'log_start'};
	}
elsif ($action eq 'error') {
	return &text('log_error', "<tt>$object</tt>");
	}
else {
	return undef;
	}
}

