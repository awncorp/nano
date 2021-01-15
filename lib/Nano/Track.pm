package Nano::Track;

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

has changed => (
  is => 'ro',
  isa => 'Changes',
  new => 1,
);

fun new_changed($self) {
  require Nano::Changes; Nano::Changes->new
}

# METHODS

method decr(Str $name) {
  $self->changed->decr($name);
  return $self->changed->get($name);
}

method del(Str $name) {
  my $value = $self->changed->get($name);
  $self->changed->del($name);
  return $value;
}

method get(Str $name) {
  return $self->changed->get($name);
}

method getpush(Str $name, Any @args) {
  return @args ? $self->push($name, @args) : $self->get($name);
}

method getset(Str $name, Any @args) {
  return @args ? $self->set($name, @args) : $self->get($name);
}

method getunshift(Str $name, Any @args) {
  return @args ? $self->unshift($name, @args) : $self->get($name);
}

method incr(Str $name) {
  $self->changed->incr($name);
  return $self->changed->get($name);
}

method merge(Str $name, HashRef $value) {
  $self->changed->merge($name, $value);
  return $self->changed->get($name);
}

method pop(Str $name) {
  my $value = do {
    my $tmp = $self->changed->get($name);
    ref($tmp) eq 'ARRAY' ? $tmp->[-1] : $tmp;
  };
  $self->changed->pop($name);
  return $value;
}

method poppush(Str $name, Any @args) {
  return @args ? $self->push($name, @args) : $self->pop($name);
}

method push(Str $name, Any @value) {
  $self->changed->push($name, @value);
  return [@value];
}

method set(Str $name, Any $value) {
  $self->changed->set($name, $value);
  return $value;
}

method shift(Str $name) {
  my $value = do {
    my $tmp = $self->changed->get($name);
    ref($tmp) eq 'ARRAY' ? $tmp->[0] : $tmp;
  };
  $self->changed->shift($name);
  return $value;
}

method shiftunshift(Str $name, Any @args) {
  return @args ? $self->unshift($name, @args) : $self->shift($name);
}

method unshift(Str $name, Any @value) {
  $self->changed->unshift($name, @value);
  return [@value];
}

1;
