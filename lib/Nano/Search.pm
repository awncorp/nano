package Nano::Search;

use 5.014;

use strict;
use warnings;

use registry 'Nano::Types';
use routines;

use Data::Object::Class;
use Data::Object::ClassHas;

# VERSION

# ATTRIBUTES

has table => (
  is => 'ro',
  isa => 'Table',
  new => 1,
);

fun new_table($self) {
  $self->nodes->nano->table($self->nodes->id)
}

has nodes => (
  is => 'ro',
  isa => 'Nodes',
  req => 1,
);

has scopes => (
  is => 'ro',
  isa => 'ArrayRef[CodeRef]',
  new => 1,
);

fun new_scopes($self) {
  []
}

# METHODS

method all() {
  $self->fetch($self->table->count)
}

method count() {
  @{$self->scopes} ? scalar(@{$self->all}) : $self->table->count
}

method fetch(Int $size = 1) {
  my $i = 0;
  my $results = [];
  my $nano = $self->nodes->nano;
  if (!$size) {
    return $results;
  }
  while (my $keyval = $self->table->next) {
    if (my $result = $self->scope($nano->object($keyval->recv))) {
      $i = push @$results, $result;
    }
    if ($i >= $size) {
      last;
    }
  }
  return $results;
}

method first() {
  my $keyval = $self->table->first or return undef;
  my $object = $keyval->recv or return undef;
  return $self->scope($self->nodes->nano->object($object));
}

method last() {
  my $keyval = $self->table->last or return undef;
  my $object = $keyval->recv or return undef;
  return $self->scope($self->nodes->nano->object($object));
}

method next() {
  my $keyval = $self->table->next or return undef;
  my $object = $keyval->recv or return undef;
  return $self->scope($self->nodes->nano->object($object));
}

method prev() {
  my $keyval = $self->table->prev or return undef;
  my $object = $keyval->recv or return undef;
  return $self->scope($self->nodes->nano->object($object));
}

method reset() {
  $self->table->reset;
  return $self;
}

method scope(Object $object) {
  if (@{$self->scopes}) {
    return (grep {!$_->($object)} @{$self->scopes}) ? undef : $object;
  }
  else {
    return $object;
  }
}

1;
