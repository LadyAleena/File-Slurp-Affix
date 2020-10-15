package File::Slurp::Affix;
use 5.006;
use strict;
use warnings;
use Exporter qw(import);

our $VERSION   = '0.01_01';
$VERSION = eval $VERSION;

our @EXPORT_OK = qw(slurp_affix);

sub slurp_affix {
  my ($filename, $opt) = @_;

  my $separator = $opt->{'separator'} ? $opt->{'separator'} : '';
  my $prefix    = $opt->{'prefix'} ? $opt->{'prefix'} . $separator : '';
  my $suffix    = $opt->{'suffix'} ? $separator . $opt->{'suffix'} : '';

  my $empty = $opt->{empty} || '';

  my $encoding = $opt->{'encoding'} || 'utf-8';
  open(my $fh, "<:encoding($encoding)", $filename) or die "Can't open $filename. $!";

  my @array;
  while ( my $line = <$fh> ) {
    chomp $line;
    my $final_line;
    if ( length($line) > 0 || $empty eq 'fill' ) {
      $final_line = $prefix . $line . $suffix;
    }
    elsif ( $empty eq 'blank' ) {
      $final_line = '';
    }
    elsif ( $empty eq 'undefined' ) {
      $final_line = undef;
    }
    else {
      next;
    }
    push @array, $final_line;
  }

  close($fh);

  return @array;
}

# This module is free software; you can redistribute it and/or modify it under the same terms as Perl itself. See https://dev.perl.org/licenses/artistic.html.
# Copyright © 2020, Lady Aleena (aleena@cpan.org). All rights reserved.

1;