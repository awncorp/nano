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
  my $table = $self->nano->table($self->id);
  my $keyval = $table->set($object->id);
  $keyval->send($object->serialize);
  return $object;
}

method all() {
  return $self->search->all;
}

method count() {
  return $self->search->count;
}

method drop() {
  my $table = $self->nano->table($self->id);
  $table->drop;
  $self->next::method;
  return $self;
}

method first() {
  return $self->search->first;
}

method get(Str $name) {
  my $table = $self->nano->table($self->id);
  my $keyval = $table->get($name) or return undef;
  my $object = $keyval->recv or return undef;
  return $self->nano->object($object);
}

method last() {
  return $self->search->last;
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
  );
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
  my $table = $self->nano->table($self->id);
  my $keyval = $table->set($object->id);
  $keyval->send($object->serialize);
  return $object;
}

1;
