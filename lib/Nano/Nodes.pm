package Nano::Nodes;

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

has scopes => (
  is => 'ro',
  isa => 'ArrayRef[CodeRef]',
  new => 1,
);

fun new_scopes($self) {
  []
}

has type => (
  is => 'ro',
  isa => 'Str',
  new => 1,
  req => 1,
);

fun new_type($self) {
  undef
}

# METHODS

method add(HashRef $data) {
  my $object = $self->nano->reify($self->type, $data);
  my $serial = $object->serialize;
  my $lookup = $self->nano->lookup($self->id);
  my $domain = $lookup->set($object->id);
  $domain->merge(object => $serial);
  return $object;
}

method all() {
  return $self->search->all;
}

method count() {
  return $self->search->count;
}

method del(Str $name) {
  my $lookup = $self->nano->lookup($self->id);
  my $object = $self->get($name);
  $lookup->del($name);
  return $object;
}

method drop() {
  my $lookup = $self->nano->lookup($self->id);
  $lookup->drop;
  return $self;
}

method first() {
  return $self->search->first;
}

method get(Str $name) {
  my $lookup = $self->nano->lookup($self->id);
  my $domain = $lookup->get($name) or return undef;
  my $object = $domain->get('object');
  return $self->nano->object($object);
}

method last() {
  return $self->search->last;
}

method next() {
  return $self->search->next;
}

method prev() {
  return $self->search->prev;
}

method scope(CodeRef $callback) {
  my $instance = ref($self)->new(
    %{$self},
    scopes => [@{$self->scopes}, $callback],
  );
  return $instance;
}

method search() {
  require Nano::Search; Nano::Search->new(
    scopes => $self->scopes,
    nodes => $self,
  )
}

method serialize() {
  $self->id;
  {
    '$name' => $self->nano->name($self),
    '$data' => $self->nano->dump($self),
    '$type' => 'nodes',
  }
}

method set(Node $object) {
  my $serial = $object->serialize;
  my $lookup = $self->nano->lookup($self->id);
  my $domain = $lookup->set($object->id);
  $domain->merge(object => $serial);
  return $object;
}

1;
