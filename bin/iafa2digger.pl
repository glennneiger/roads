#!/usr/bin/perl
use lib "/home/roads2/lib";

# convert strict-ish IAFA templates generated by the ROADS template
# editor to the format accepted by Digger this week... :-) - should be
# good for Digger version 2

# Author: Martin Hamilton <martinh@gnu.org>
# $Id: iafa2digger.pl,v 3.7 1998/08/18 19:31:28 martin Exp $

use Getopt::Std;
use Cwd;

getopts("ado:s:");

require ROADS;

$debug = $opt_d || 0;
$OUTLINEDIR= $opt_o || "$ROADS::Config/outlines";
$SOURCEDIR = $opt_s || "$ROADS::IafaSource";

if ($opt_a) {
  undef @ARGV;
  opendir(ALLFILES, "$SOURCEDIR")
    || die "$0: Can't open $SOURCEDIR directory: $!";
  @ARGV = readdir(ALLFILES);
  closedir(ALLFILES);
  -d "$SOURCEDIR" && chdir "$SOURCEDIR";
}

print "% 600 ISO-8859-1\n";

foreach $template (@ARGV) {
  undef(%AV);
  next if $template =~ /^\./;
  open(IN, "$template") || print STDERR "$0: Can't open $template: $!", next;
  print ">> inspecting ... $template\n" if $debug;
  while(<IN>) {
    chomp;
  
    s/\t/ /g;
    s/\s+/ /g;
  
    /^template-type:\s+(.*)/i && ($TT=$1);
    /^handle:\s+(.*)/i && ($HANDLE=$1);

    next if /:(\s+|)$/;
  
    if (/^\s/ && $value) { # continuation line
      $value .= "$_";
      next;
    }
  
    if (/^([^\s:]+)\s/ && $value) { # hmm...  blooper ?  try to recover
      $value .= "$_"; 
      next;
    }

    if (/^([^:]+):\s+(.*)/) { # easy!  attrib: value
      if ($attrib) {
        $AV{$vattrib} = "$attrib: $value";
        print "<< AV{$vattrib} = $attrib: $value\n" if $debug;
      }
  
      $vattrib = $attrib = $1; $value = $2;
      $attrib =~ s/-v\d+//;
      $vattrib =~ tr/[a-z]/[A-Z]/;
    }
  }
  close (IN);

  print "# FULL $TT LOCAL $HANDLE\n"; 

  print STDERR "No template type!", next unless $TT;
  $TT =~ tr/[A-Z]/[a-z]/;
  
  @avkeys = keys(%AV);
  
  open(OUTLINE, "$OUTLINEDIR/$TT") 
    || print STDERR "Can't open template outline $OUTLINEDIR/$TT: $!", next;
  while(<OUTLINE>) {
    chomp;
    next if /^template-type:/i;
    next if /^handle:/i;
    s/:.*//;
    $check = $_;
    $check =~ tr/[a-z]/[A-Z]/;
    print ">> $check\n" if $debug;

    unless (/\(/ || /-v\*/i) { # plain attrib 
      &prettyprint(" $AV{$check}\n") if $AV{$check};
      next;
    }

    unless (/\(/) { # unclustered variant
      $base = $_;
      $base =~ s/-v\*//i;
      $variant=1;
      while(1) {
        print ">> looking for variant $base-V$variant\n" if $debug;
        @cluster = grep(/$base-V$variant/, @avkeys);
        last if $#cluster < 0;
        foreach (@cluster) { &prettyprint(" $AV{$_}\n"); }
        $variant++;
      }
      next;
    }

    # must be including a cluster here...
    $base=$include="";
    $_ =~ tr/[a-z]/[A-Z]/;
    /^([^\(]+)\(([^\*]+)\*\)/ && ($base = $1, $include = $2);
    $variant=1;
    while(1) {
      print ">> looking for cluster $base($include)-V$variant\n" if $debug;
      @cluster = grep(/$base.+-V$variant/, @avkeys);
      last if $#cluster < 0;
      foreach (@cluster) { &prettyprint(" $AV{$_}\n"); }
      $variant++;
    }
  }
  close(OUTLINE);

  print "# END\n";
}

sub prettyprint {
  local($_)=@_;

  print ">> prettyprint: $_\n" if $debug;

  if (length($_) < 70) { print "$_"; return; }

  s/\s+/ /g;

  If (/^(.{75})(.*)/) {
    print "$1\n";
    &prettyprint("+$2\n");
  } else {
    print "$_\n";
  }
}

exit;
__END__


=head1 NAME

B<bin/iafa2digger.pl> - convert IAFA templates to Digger v2 input format

=head1 SYNOPSIS

  bin/iafa2digger.pl [-ad] [-o outlinedir] [-s sourcedir]
    [file1 file2 ... fileN]
 
=head1 DESCRIPTION

This Perl program converts IAFA templates such as those generated by
the ROADS template editor into the format accepted by version 2 of
Bunyip's "Digger" WHOIS++ server.  This is necessary because Digger
takes its input in the WHOIS++ on-the-wire format, which is slightly
different to the IAFA templates used internally within the ROADS
software.

=head1 OPTIONS

=over 4

=item B<-a>

Process all of the templates in the source directory.

=item B<-d>

Generate debugging information.

=item B<-o> I<outlinedir>

Use the template outline descriptions (the attributes and values which
are legal in each template and cluster) from this directory.

=item B<-s> I<sourcedir>

Look in this directory for the templates being converted.

=back

=head1 OUTPUT

A single file containing the Digger formatted templates.

=head1 COPYRIGHT

Copyright (c) 1988, Martin Hamilton E<lt>martinh@gnu.orgE<gt> and Jon
Knight E<lt>jon@net.lut.ac.ukE<gt>.  All rights reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

It was developed by the Department of Computer Studies at Loughborough
University of Technology, as part of the ROADS project.  ROADS is funded
under the UK Electronic Libraries Programme (eLib), the European
Commission Telematics for Research Programme, and the TERENA
development programme.

=head1 AUTHOR

Martin Hamilton E<lt>martinh@gnu.orgE<gt>
