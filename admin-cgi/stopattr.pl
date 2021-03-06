#!/usr/bin/perl
use lib "/home/roads2/lib";

# stopattr.pl - render stopped attributes as HTML
#
# Author: Martin Hamilton <martinh@gnu.org>
# $Id: stopattr.pl,v 3.10 1998/08/18 19:24:45 martin Exp $

require ROADS;
use ROADS::Auth;
use ROADS::CGIvars;
use ROADS::ErrorLogging;

&cleaveargs;
&CheckUserAuth("stopattr_users");

print <<EOF;
Content-type: text/html

<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<HTML>
<HEAD>
<TITLE>Indexing stoplist for attributes</TITLE>
</HEAD>
<BODY>

<H1>Indexing stoplist for attributes</H1>

<PRE>
EOF

open(IN, "$ROADS::Config/stopattr")
  || &WriteToErrorLogAndDie("stopattr",
       "Can't open $ROADS::Config/stopattr: $!");
while(<IN>) { print $_; }
close(IN);

print <<EOF;
</PRE>
<HR>
[<A HREF="/$ROADS::WWWAdminCgi/admincentre.pl">ROADS Admin Centre</A>]
</BODY>
</HTML>
EOF

exit;
__END__


=head1 NAME

B<admin-cgi/stopattr.pl> - render stopped attributes as HTML

=head1 SYNOPSIS

  admin-cgi/stopattr.pl
 
=head1 DESCRIPTION

This Perl program reads in the list of attributes which are not
indexed by the ROADS software, and renders it as an HTML document.

=head1 OPTIONS

None.

=head1 FILES

I<config/stopattr> - attributes which are not normally indexed

=head1 COPYRIGHT

Copyright (c) 1988, Martin Hamilton E<lt>martinh@gnu.orgE<gt> and Jon
Knight E<lt>jon@net.lut.ac.ukE<gt>.  All rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

It was developed by the Department of Computer Studies at Loughborough
University of Technology, as part of the ROADS project.  ROADS is funded
under the UK Electronic Libraries Programme (eLib), the European
Commission Telematics for Research Programme, and the TERENA
development programme.

=head1 AUTHOR

Martin Hamilton E<lt>martinh@gnu.orgE<gt>


