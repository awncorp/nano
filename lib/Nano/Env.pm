package Nano::Env;

use 5.014;

use strict;
use warnings;

use registry 'Nano::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

extends 'Zing::Env';

# VERSION

# ATTRIBUTES

has system => (
  is => 'ro',
  init_arg => undef,
  isa => 'Str',
  default => 'nano',
);

1;
