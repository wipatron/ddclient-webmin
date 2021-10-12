do 'ddclient-lib.pl';

sub acl_security_form
{
	print "<tr> <td><b>$text{'edit_can_edit'}</td>\n";
	printf "<td><input type=radio name=edit value=1 %s> $text{'yes'}\n", $_[0]->{'edit'} ? 'checked' : '';
	printf "<input type=radio name=edit value=0 %s> $text{'no'}</td> </tr>\n", $_[0]->{'edit'} ? '' : 'checked';
}

sub acl_security_save
{
	$_[0]->{'edit'} = $in{'edit'};
	$_[0]->{'config'} = $in{'config'};
}
