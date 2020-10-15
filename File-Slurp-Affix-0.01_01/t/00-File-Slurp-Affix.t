#!perl
use strict;
use warnings;
use Test::More;
use File::Temp qw(tempfile);
use Encode qw(encode);

BEGIN {
  use_ok( 'File::Slurp::Affix', qw(slurp_affix) )
    or BAIL_OUT("File::Slurp::Affix is not available\n");
}

diag( "Testing File::Slurp::Affix $File::Slurp::Affix::VERSION, Perl $], $^X" );

my @wanted_array = qw(red orange yellow spring green teal cyan azure blue violet magenta pink white black gray);

my @solid_array             = map( "solid$_",       @wanted_array );
my @bead_array              = map( "${_}bead",      @wanted_array );
my @solid_bead_array        = map( "solid${_}bead", @wanted_array );
my @solid_array_separator      = map( "solid $_",      @wanted_array );
my @bead_array_separator       = map( "$_ bead",       @wanted_array );
my @solid_bead_array_separator = map( "solid $_ bead", @wanted_array );

my $file_string = join( "\n", @wanted_array );

# Testing encoding

my ($fh, $fn) = tempfile();
$fh->print($file_string);
$fh->close();

is_deeply(
  [ File::Slurp::Affix::slurp_affix($fn) ],
  [ map encode('utf8', $_), @wanted_array ],
  "testing an array opened with no options"
);

my @encodings = qw(UTF-8 ascii cp1252 iso-8859-1);

for my $encoding (@encodings) {

  is_deeply(
    [ File::Slurp::Affix::slurp_affix($fn, { 'encoding' => $encoding }) ],
    [ map encode($encoding, $_), @wanted_array ],
    "testing an array opened with $encoding encoding"
  );

}

# Testing
# Uses same file used to test encoding

is_deeply(
  [ File::Slurp::Affix::slurp_affix($fn) ],
  [ @wanted_array ],
  "testing a plain array"
);

# Testing prefix and suffix options

is_deeply(
  [ File::Slurp::Affix::slurp_affix($fn, { 'prefix' => 'solid' }) ],
  [ @solid_array ],
  "testing an array with prefix option"
);

is_deeply(
  [ File::Slurp::Affix::slurp_affix($fn, { 'suffix' => 'bead' }) ],
  [ @bead_array ],
  "testing an array with suffix option"
);

is_deeply(
  [ File::Slurp::Affix::slurp_affix($fn, { 'prefix' => 'solid', 'suffix' => 'bead' }) ],
  [ @solid_bead_array ],
  "testing an array with prefix and suffix options"
);

# Testing separator option

is_deeply(
  [ File::Slurp::Affix::slurp_affix($fn, { 'prefix' => 'solid', 'separator' => ' ' }) ],
  [ @solid_array_separator ],
  "testing an array with prefix and separator options"
);

is_deeply(
  [ File::Slurp::Affix::slurp_affix($fn, { 'suffix' => 'bead', 'separator' => ' ' }) ],
  [ @bead_array_separator ],
  "testing an array with suffix and separator options"
);

is_deeply(
  [ File::Slurp::Affix::slurp_affix($fn, { 'prefix' => 'solid', 'suffix' => 'bead', 'separator' => ' ' }) ],
  [ @solid_bead_array_separator ],
  "testing an array with prefix, suffix, and separator options"
);

# Testing with file that has a blank line in it

my @empty_line_array = @wanted_array;
splice( @empty_line_array, 8, 0, '' );
my $file_with_empty_line_string = join( "\n", @empty_line_array);

my @solid_bead_empty_line_array = map( "solid${_}bead", @empty_line_array );

my ($fh_with_empty_line, $file_with_empty_line) = tempfile();
$fh_with_empty_line->print($file_with_empty_line_string);
$fh_with_empty_line->close();

is_deeply(
  [ File::Slurp::Affix::slurp_affix($file_with_empty_line, { 'prefix' => 'solid', 'suffix' => 'bead' }) ],
  [ @solid_bead_array ],
  "testing a plain array with file with an empty line with no empty option"
);

$solid_bead_empty_line_array[8] = "solidbead";
is_deeply(
  [ File::Slurp::Affix::slurp_affix($file_with_empty_line, { 'prefix' => 'solid', 'suffix' => 'bead', 'empty' => 'fill' }) ],
  [ @solid_bead_empty_line_array ],
  "testing a plain array with file with an empty line with 'fill' empty option"
);

$solid_bead_empty_line_array[8] = '';
is_deeply(
  [ File::Slurp::Affix::slurp_affix($file_with_empty_line, { 'prefix' => 'solid', 'suffix' => 'bead', 'empty' => 'blank' }) ],
  [ @solid_bead_empty_line_array ],
  "testing a plain array with file with an empty line with 'blank' empty option"
);

$solid_bead_empty_line_array[8] = undef;
is_deeply(
  [ File::Slurp::Affix::slurp_affix($file_with_empty_line, { 'prefix' => 'solid', 'suffix' => 'bead', 'empty' => 'undefined' }) ],
  [ @solid_bead_empty_line_array ],
  "testing a plain array with file with an empty line with 'undefined' empty option"
);

# Testing with file that ends with a newline

my ($newline_fh, $newline_file) = tempfile();
$newline_fh->print("$file_string\n");
$newline_fh->close();

is_deeply(
  [ File::Slurp::Affix::slurp_affix($newline_file) ],
  [ @wanted_array ],
  "testing an array opened with no options with file that ends with a newline"
);

done_testing();

# Written with the help of tobyink, davido, chromatic, and perlfan on PerlMonks.
# https://www.perlmonks.org/?node_id=11121949
# Writen with the help of rindolf in #perlcafe on Freenode