#!/usr/bin/perl
#
# Author:	D. Bierer <doug@unlikelysource.com>
# Date:		24 Jan 2009
# Notes:	None
#

do 'ddclient-lib.pl';

# is_installed(mode)
# For mode 1, returns 2 if /usr/sbin/ddclient is installed and configured for use by
# Webmin, 1 if installed but not configured, or 0 otherwise.
# For mode 0, returns 1 if installed, 0 if not

sub is_installed
{
	
	if (-r $config{'exec1'}) {
		$result = 1;
	} else {
		$result = 0;
	}
	
	return $result;

}
