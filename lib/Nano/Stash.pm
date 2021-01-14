package Nano::Stash;

use 5.014;

use strict;
use warnings;

use registry 'Nano::Types';
use routines;

use Data::Object::Role;
use Data::Object::RoleHas;

requires 'nano';

# VERSION

# ATTRIBUTES

has stashed => (
  is => 'ro',
  isa => 'HashRef',
  new => 1,
);

fun new_stashed($self) {
  {}
}

# METHODS

method get(Str $name) {
  my $id = $self->stashed->{$name};
  return $id ? $self->nano->find($id) : undef;
}

method set(Str $name, Node $node) {
  $self->stashed->{$name} = $node->id;
  return $node;
}

method stash(Str $name, Maybe[Node] $node) {
  return $node ? $self->set($name, $node) : $self->get($name);
}

1;
