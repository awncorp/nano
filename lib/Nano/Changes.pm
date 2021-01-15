package Nano::Changes;

use 5.014;

use strict;
use warnings;

use registry 'Nano::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

extends 'Nano::Node';

# VERSION

# ATTRIBUTES

has domain => (
  is => 'ro',
  isa => 'Domain',
  hnd => [qw(decr del get incr merge pop push set shift state unshift)],
  new => 1,
);

fun new_domain($self) {
  $self->nano->domain($self->id)
}

1;
