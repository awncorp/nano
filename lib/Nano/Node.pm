package Nano::Node;

use 5.014;

use strict;
use warnings;

use registry 'Nano::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

# VERSION

# ATTRIBUTES

has id => (
  is => 'ro',
  isa => 'Str',
  new => 1,
);

fun new_id($self) {
  require Zing::ID; Zing::ID->new->string
}

has nano => (
  is => 'ro',
  isa => 'Nano',
  new => 1,
);

fun new_nano($self) {
  require Nano; Nano->new
}

# METHODS

method drop() {
  my $keyval = $self->nano->keyval($self->id);
  $keyval->drop;
  return $self;
}

method load() {
  return $self->nano->find($self->id);
}

method save() {
  my $serial = $self->serialize;
  my $keyval = $self->nano->keyval($self->id);
  $keyval->send($serial);
  return $keyval->term;
}

method serialize() {
  $self->id;
  {
    '$name' => $self->nano->name($self),
    '$data' => $self->nano->dump($self),
    '$type' => 'node',
  }
}

1;
