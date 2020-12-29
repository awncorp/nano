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

has cursor => (
  is => 'ro',
  isa => 'Cursor',
  new => 1,
);

fun new_cursor($self) {
  $self->lookup->cursor
}

has lookup => (
  is => 'ro',
  isa => 'Lookup',
  new => 1,
);

fun new_lookup($self) {
  $self->nodes->nano->lookup($self->nodes->id)
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
  $self->fetch($self->cursor->count)
}

method count() {
  @{$self->scopes} ? scalar(@{$self->all}) : $self->cursor->count
}

method fetch(Int $size = 1) {
  my $i = 0;
  my $results = [];
  my $nano = $self->nodes->nano;
  if (!$size) {
    return $results;
  }
  while (my $domain = $self->cursor->next) {
    if (my $result = $self->scope($nano->object($domain->get('object')))) {
      $i = push @$results, $result;
    }
    if ($i >= $size) {
      last;
    }
  }
  return $results;
}

method first() {
  my $domain = $self->cursor->first or return undef;
  my $object = $domain->get('object') or return undef;
  return $self->scope($self->nodes->nano->object($object));
}

method last() {
  my $domain = $self->cursor->last or return undef;
  my $object = $domain->get('object') or return undef;
  return $self->scope($self->nodes->nano->object($object));
}

method next() {
  my $domain = $self->cursor->next or return undef;
  my $object = $domain->get('object') or return undef;
  return $self->scope($self->nodes->nano->object($object));
}

method prev() {
  my $domain = $self->cursor->prev or return undef;
  my $object = $domain->get('object') or return undef;
  return $self->scope($self->nodes->nano->object($object));
}

method reset() {
  $self->cursor->reset;
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
