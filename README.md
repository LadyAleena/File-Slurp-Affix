# File::Slurp::Affix

**File::Slurp::Affix** opens a file and creates an array with an optional prefix, suffix, or both with an optional separator in your preferred encoding.

- [Version](#version)
- [Synopsis](#synopsis)
- [Description](#description)
  - [Parameters](#parameters)
    - [File](#file)
    - [Options](#options)
      - [prefix](#prefix)
      - [suffix](#suffix)
      - [prefix and suffix](#prefix-and-suffix)
      - [separator](#separator)
      - [empty](#empty)
      - [encoding](#encoding)
- [Dependency](#dependency)
- [Installation](#installation)
- [Support](#support)
- [Author](#author)
- [License and copyright](#license-and-copyright)

## Version

This document describes File::Slurp::Affix version 0.01\_01.

## Synopsis

```perl
use File::Slurp::Affix qw(slurp_affix);

my @plain_array      = slurp_affix($file);

my @prefix_array     = slurp_affix($file, { 'prefix' => 'foo' });

my @suffix_array     = slurp_affix($file, { 'suffix' => 'bar' });

my @both_array       = slurp_affix($file, { 'prefix' => 'foo', 'suffix' => 'bar' });

my @separator_array  = slurp_affix($file, { 'prefix' => 'foo', 'suffix' => 'bar', 'separator' => ' ' });

my @empty_line       = slurp_affix($file, { 'empty' => 'fill' });

my @encoded_array    = slurp_affix($file, { 'encoding' => 'ascii' });
```

## Description

`slurp_affix` can be exported and returns a list of values. These values can be modified if the optional parameters `prefix`, `suffix`, or both are used. There is the additional option to choose your `encoding`, the default is `utf-8`.

If the open fails, `slurp_affix` will die.

```perl
my @fancy_array = slurp_affix(
  $file,
  {
    'prefix' => $prefix_string,
    'suffix' => $suffix_string,
    'separator' => $separator_string,
    'empty'  => $empty_option,
    'encoding' => $encoding_option
  }
);
```

The file is also closed by `slurp_affix`.

`File::Slurp::Affix` requires Perl version 5.6 or better.

### Parameters

`slurp_affix` has two parameters.

**Note:** all sample returned arrays are the results from [Data::Dump](https://metacpan.org/pod/Data%3A%3ADump).

Sample file contents.

```
red
orange
yellow
spring
green
teal
cyan
azure
blue
violet
magenta
pink
white
black
gray
```

#### file

```perl
my @plain_array = slurp_affix($file);
```

The first parameter is the file to be opened. If this is the only parameter specified, the file will be opened, encoded to `utf-8`, and returned as a list.

#### Options

The second parameter are the options: `prefix`, `suffix`, `separator`, `encoding`, and `empty`.

##### prefix

```perl
my @prefix_array = slurp_affix($file, { 'prefix' => 'solid' });
```

The `prefix` option is the string you want prepended to each item in the list. Using the example, all items on the list will be returned with `foo` prepended to them.

```perl
(
  "solidred",
  "solidorange",
  "solidyellow",
  "solidspring",
  "solidgreen",
  "solidteal",
  "solidcyan",
  "solidazure",
  "solidblue",
  "solidviolet",
  "solidmagenta",
  "solidpink",
  "solidwhite",
  "solidblack",
  "solidgray",
)
```

##### suffix

```perl
my @suffix_array = slurp_affix($file, { 'suffix' => 'bead; });
```

The `suffix` option is the string you want to appear appended to each item in the list. Using the example, all items on the list will be returned with `bar` appended to them.

```perl
(
  "redbead",
  "orangebead",
  "yellowbead",
  "springbead",
  "greenbead",
  "tealbead",
  "cyanbead",
  "azurebead",
  "bluebead",
  "violetbead",
  "magentabead",
  "pinkbead",
  "whitebead",
  "blackbead",
  "graybead",
)
```

##### prefix and suffix

```perl
my @both_array = slurp_affix($file, { 'prefix' => 'solid', 'suffix' => 'bead' });
```

Using both the `prefix` and `suffix` options together will prepend and append the associated strings to the items in the list.

```perl
(
  "solidredbead",
  "solidorangebead",
  "solidyellowbead",
  "solidspringbead",
  "solidgreenbead",
  "solidtealbead",
  "solidcyanbead",
  "solidazurebead",
  "solidbluebead",
  "solidvioletbead",
  "solidmagentabead",
  "solidpinkbead",
  "solidwhitebead",
  "solidblackbead",
  "solidgraybead",
)
```

##### separator

```perl
my @separator_array = slurp_affix($file, { 'prefix' => 'solid', 'suffix' => 'bead', 'separator' => ' ' });
```

The `separator` option will add a string between the prefix, the line from the file, and the suffix. In this case, a single space.

```perl
(
  "solid red bead",
  "solid orange bead",
  "solid yellow bead",
  "solid spring bead",
  "solid green bead",
  "solid teal bead",
  "solid cyan bead",
  "solid azure bead",
  "solid blue bead",
  "solid violet bead",
  "solid magenta bead",
  "solid pink bead",
  "solid white bead",
  "solid black bead",
  "solid gray bead",
)
```

##### empty

```perl
my @empty_line = slurp_affix($file, { 'empty' => 'fill' });
```

The `empty` option has three possible values for what to do with empty lines in the file: `fill`, `blank`, or `undefined`. If `empty` is not used or is any value than the three listed, the empty line will be ignored.

Sample file contents with an empty line.

```
red
orange
yellow
spring
green
teal
cyan
azure

blue
violet
magenta
pink
white
black
gray
```

- `fill` will prefix and suffix the value as it does with all other lines.

  ```perl
  my @empty_line = slurp_affix($file, { 'prefix' => 'solid', 'empty' => 'fill' });
  ```
  The array returned will be:

  ```perl
  (
    "solidred",
    "solidorange",
    "solidyellow",
    "solidspring",
    "solidgreen",
    "solidteal",
    "solidcyan",
    "solidazure",
    "solid",
    "solidblue",
    "solidviolet",
    "solidmagenta",
    "solidpink",
    "solidwhite",
    "solidblack",
    "solidgray",
  )
  ```

- `blank` will return a zero length but defined value.

  ```perl
  my @empty_line = slurp_affix($file, { 'prefix' => 'solid', 'empty' => 'blank' });
  ```
  The array returned will be:

  ```perl
  (
    "solidred",
    "solidorange",
    "solidyellow",
    "solidspring",
    "solidgreen",
    "solidteal",
    "solidcyan",
    "solidazure",
    "",
    "solidblue",
    "solidviolet",
    "solidmagenta",
    "solidpink",
    "solidwhite",
    "solidblack",
    "solidgray",
  )
  ```

- `undefined` will return an undefined value.

  ```perl
  my @empty_line = slurp_affix($file, { 'prefix' => 'solid', 'empty' => 'undefined' });
  ```

  The array returned will be:

  ```perl
  (
    "solidred",
    "solidorange",
    "solidyellow",
    "solidspring",
    "solidgreen",
    "solidteal",
    "solidcyan",
    "solidazure",
    undef,
    "solidblue",
    "solidviolet",
    "solidmagenta",
    "solidpink",
    "solidwhite",
    "solidblack",
    "solidgray",
  )
  ```

##### encoding

```perl
my @encoded_array = slurp_affix($file, { 'encoding' => 'ascii' });
```

The `encoding` option is the encoding you want to use to open the file. The above file will be opened `ascii` encoded.

## Dependency

File::Slurp::Affix depends on [Exporter](https://metacpan.org/pod/Exporter).

## Installation

To install this module use your preferred CPAN installer or run the following commands:

  perl Makefile.PL
  make
  make test
  make install

## Support

You can find documentation for this module with the perldoc command.

```
perldoc File::Slurp::Affix
```

You can also look for information at:

- [File::Slurp::Affix on GitHub](https://github.com/LadyAleena/File-Slurp-Affix) ([issues](https://github.com/LadyAleena/File-Slurp-Affix/issues))
- [File::Slurp::Affix on Meta::CPAN](https://metacpan.org/release/File-Slurp-Affix)
- [File::Slurp::Affix on CPAN Ratings](https://cpanratings.perl.org/d/File-Slurp-Affix)

## Author

Lady Aleena

## License and copyright

This module is free software; you can redistribute it and/or modify it under the same terms as Perl itself. See [perlartistic](https://metacpan.org/pod/perlartistic).

Copyright © 2020, Lady Aleena `(aleena@cpan.org)`. All rights reserved.
