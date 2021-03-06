#!/usr/bin/perl
use lib "/home/roads2/lib";

# report.pl - WWW front end to link checker report generator
#
# Author: Martin Hamilton <martinh@gnu.org>
# $Id: report.pl,v 3.10 1998/08/18 19:24:45 martin Exp $

require ROADS;
use ROADS::Auth;
use ROADS::CGIvars;
use ROADS::ErrorLogging;

&cleaveargs;
&CheckUserAuth("report_users");

print <<EOF;
Content-type: text/html

<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<HTML>
<HEAD>
<TITLE>Link checker summary report</TITLE>
</HEAD>
<BODY>

<H1>Link checker summary report</H1>

<PRE>
EOF

open(IN, "$ROADS::Bin/report.pl -h|")
  || &WriteToErrorLogAndDie("report",
       "Can't open pipe to $ROADS::Bin/report.pl: $!");
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

B<admin-cgi/report.pl> - WWW front end to link checker report generator

=head1 SYNOPSIS

  admin-cgi/report.pl
 
=head1 DESCRIPTION

This Perl program runs B<report.pl>, the ROADS link checker report
generation tool, and generates an HTML document from the results.

=head1 OPTIONS

None.

=head1 OUTPUT

Link checker summary report.

=head1 SEE ALSO

L<bin/report.pl>

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


