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

has orders => (
  is => 'ro',
  isa => 'ArrayRef[CodeRef]',
  new => 1,
);

fun new_orders($self) {
  []
}

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
  my $nano = $self->nodes->nano;
  my $results = [];
  if (!$size) {
    return $results;
  }
  $self->reset;
  while (my $keyval = $self->table->next) {
    if (my $result = $self->scope($nano->object($keyval->recv))) {
      $i = push @$results, $result;
    }
    if ($i >= $size) {
      last;
    }
  }
  return $self->order($results);
}

method first() {
  my $results;
  my $nano = $self->nodes->nano;
  $self->table->position(undef);
  if (@{$self->orders}) {
    $results = $self->all->[0];
  }
  else {
    $self->reset;
    while (my $keyval = $self->table->next) {
      if (my $result = $self->scope($nano->object($keyval->recv))) {
        $results = $result;
        last;
      }
    }
  }
  return $results;
}

method last() {
  my $results;
  my $nano = $self->nodes->nano;
  $self->table->position($self->table->size);
  if (@{$self->orders}) {
    $results = $self->all->[-1];
  }
  else {
    $self->table->position($self->table->size);
    while (my $keyval = $self->table->prev) {
      if (my $result = $self->scope($nano->object($keyval->recv))) {
        $results = $result;
        last;
      }
    }
  }
  return $results;
}

method next() {
  my $results = [];
  my $nano = $self->nodes->nano;
  if (@{$self->orders}) {
    my $skip = 1;
    for my $item (@{$self->all}) {
      if (defined $self->{last_next}) {
        if ($self->{last_next} == $item->id) {
          $skip = 0;
        }
        next if $skip;
      }
      push @$results, $item;
      $self->{last_next} = $item->id;
      last;
    }
  }
  else {
    while (my $keyval = $self->table->next) {
      if (my $result = $self->scope($nano->object($keyval->recv))) {
        push @$results, $result;
        last;
      }
    }
  }
  return $results->[0];
}

method order(ArrayRef $result) {
  if (@{$self->orders}) {
    for my $order (@{$self->orders}) {
      $result = [sort {$order->($a,$b)} @$result];
    }
    return $result;
  }
  else {
    return $result;
  }
}

method prev() {
  my $results = [];
  my $nano = $self->nodes->nano;
  if (@{$self->orders}) {
    my $skip = 1;
    for my $item (reverse(@{$self->all})) {
      if (defined $self->{last_prev}) {
        if ($self->{last_prev} == $item->id) {
          $skip = 0;
        }
        next if $skip;
      }
      push @$results, $item;
      $self->{last_prev} = $item->id;
      last;
    }
  }
  else {
    while (my $keyval = $self->table->prev) {
      if (my $result = $self->scope($nano->object($keyval->recv))) {
        push @$results, $result;
        last;
      }
    }
  }
  return $results->[0];
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
